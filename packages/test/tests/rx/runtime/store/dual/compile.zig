const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const nested = std.mem.startsWith(u8, args[1], "nested");
    const memory = std.mem.startsWith(u8, args[1], "memory");
    const mode = std.meta.stringToEnum(enum { isolation, @"union", nested, nested_deep, memory, memory_borrowed, memory_readonly, memory_failure, memory_pure_readonly }, args[1]) orelse return error.InvalidMode;

    const entry_source = switch (mode) {
        .memory_failure => @embedFile("fixtures/memory_failure.rx"),
        .memory_pure_readonly => @embedFile("fixtures/memory_pure_readonly.rx"),
        .nested_deep => @embedFile("fixtures/nested_deep.rx"),
        .nested => @embedFile("fixtures/nested.rx"),
        .@"union", .memory_readonly => @embedFile("fixtures/union.rx"),
        else => @embedFile("fixtures/main.rx"),
    };

    const texts = [_][]const u8{
        entry_source,
        if (std.mem.eql(u8, args[1], "memory_failure")) @embedFile("fixtures/memory_write_left.rx") else if (nested) @embedFile("fixtures/permuted.rx") else @embedFile("fixtures/write_left.rx"),
        if (nested) @embedFile("fixtures/bridge.rx") else @embedFile("fixtures/write_right.rx"),
        @embedFile("fixtures/left.store.rx"),
        @embedFile("fixtures/right.store.rx"),
    };

    var parsed: [5]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        if (item.value != .node) return error.InvalidXml;
    }

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = &.{
            .{ .path = "main.rx", .node = parsed[0].value.node },
            .{ .path = if (nested) "permuted.rx" else "write_left.rx", .node = parsed[1].value.node },
            .{ .path = if (nested) "bridge.rx" else "write_right.rx", .node = parsed[2].value.node },
        },
        .stores = &.{
            .{ .path = "left.store.rx", .node = parsed[3].value.node },
            .{ .path = "right.store.rx", .node = parsed[4].value.node },
        },
        .sources = &.{
            .{ .path = "advance.zx", .source = if (mode == .memory_borrowed) @embedFile("fixtures/advance_borrowed.zx") else @embedFile("fixtures/advance.zx") },
            .{ .path = "snapshot.zx", .source = @embedFile("fixtures/snapshot.zx") },
            .{ .path = "snapshot_before_left.zx", .source = @embedFile("fixtures/snapshot.zx") },
            .{ .path = "snapshot_before_right.zx", .source = @embedFile("fixtures/snapshot.zx") },
            .{ .path = "snapshot_untouched.zx", .source = @embedFile("fixtures/snapshot.zx") },
            .{ .path = "snapshot_after_left.zx", .source = @embedFile("fixtures/snapshot.zx") },
            .{ .path = "snapshot_after_right.zx", .source = @embedFile("fixtures/snapshot.zx") },
            .{ .path = "read_pair.zx", .source = @embedFile("fixtures/read_pair.zx") },
            .{ .path = "read_pair_after.zx", .source = @embedFile("fixtures/read_pair.zx") },
            .{ .path = "write_pair.zx", .source = @embedFile("fixtures/write_pair.zx") },
            .{ .path = "write_pair_overlap.zx", .source = @embedFile("fixtures/write_pair.zx") },
            .{ .path = "write_pair_only.zx", .source = @embedFile("fixtures/write_pair.zx") },
            .{ .path = "write_left_pair.zx", .source = @embedFile("fixtures/write_left_pair.zx") },
            .{ .path = "advance_failure.zx", .source = @embedFile("fixtures/advance_failure.zx") },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidContract;
    }

    const contract = result.value.contract;

    if (contract.program.stores.count() != 2 or contract.store_definitions.len != 2) return error.InvalidStoreCount;
    if (try compiler.validateIr(allocator, contract.program) != null) return error.InvalidIr;

    if (nested) {
        var permuted = false;

        for (0..contract.program.expressions.count()) |expression_index| {
            const expression = contract.program.expressions.at(expression_index);

            if (expression.value == .call and std.mem.eql(u32, expression.value.call.stores, &.{ 1, 0 })) permuted = true;
        }

        if (!permuted) return error.MissingStorePermutation;
    }

    if (memory) return @import("emit_state.zig").write(init, contract, args[2]);

    const bundle = try compiler.zig.emitBundle(allocator, contract.program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.types });

    for ([_][]const u8{ "store.left.store.rx:counter", "store.right.store.rx:counter" }, 0..) |identity, index| {
        if (!std.mem.eql(u8, contract.program.stores.at(index).path, identity)) return error.InvalidStoreIdentity;
        if (contract.store_definitions[index].objects.len != 1) return error.InvalidObjectCount;

        const initial = contract.store_definitions[index].objects[0].initial;

        if (try compiler.validateIr(allocator, initial) != null) return error.InvalidInitialIr;

        const initial_bundle = try compiler.zig.emitBundle(allocator, initial);

        defer initial_bundle.deinit(allocator);

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[index + 4], .data = initial_bundle.source });
    }
}
