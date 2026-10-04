const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const services = std.mem.eql(u8, args[1], "store_services");

    const texts = [_][]const u8{
        if (services) @embedFile("fixtures/services.rx") else @embedFile("fixtures/main.rx"),
        @embedFile("fixtures/advance.rx"),
        @embedFile("fixtures/state.store.rx"),
        @embedFile("fixtures/bridge.rx"),
        @embedFile("fixtures/read_state.rx"),
    };

    var parsed: [5]rx.XmlResult = undefined;
    var count: usize = 0;

    defer for (parsed[0..count]) |*item| item.deinit();

    for (texts, &parsed) |text, *item| {
        item.* = try rx.parseXml(allocator, text);
        count += 1;

        if (item.value != .node) return error.InvalidXml;
    }

    const modules = [_]rx.ModuleSource{
        .{ .path = "main.rx", .node = parsed[0].value.node },
        .{ .path = "advance.rx", .node = parsed[1].value.node },
        .{ .path = "bridge.rx", .node = parsed[3].value.node },
        .{ .path = "read_state.rx", .node = parsed[4].value.node },
    };

    var result = try analysis.project.infer(allocator, .{
        .entry = "main.rx",
        .modules = modules[0..(if (services) @as(usize, 4) else 2)],
        .stores = &.{.{ .path = "state.store.rx", .node = parsed[2].value.node }},
        .sources = &.{
            .{ .path = "advance.zx", .source = @embedFile("fixtures/advance.zx") },
            .{ .path = "read.zx", .source = @embedFile("fixtures/read.zx") },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidContract;
    }

    const contract = result.value.contract;

    if (contract.program.stores.len != 1 or contract.store_definitions.len != 1 or contract.store_definitions[0].objects.len != 1) return error.InvalidStoreCount;
    if (!std.mem.eql(u8, contract.program.stores[0].path, "store.state.store.rx:counter")) return error.InvalidStoreIdentity;
    if (try compiler.validateIr(allocator, contract.program) != null) return error.InvalidIr;

    const initial = contract.store_definitions[0].objects[0].initial;

    if (try compiler.validateIr(allocator, initial) != null) return error.InvalidInitialIr;

    const bundle = try compiler.zig.emitBundle(allocator, contract.program);

    defer bundle.deinit(allocator);

    const initial_bundle = try compiler.zig.emitBundle(allocator, initial);

    defer initial_bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.types });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4], .data = initial_bundle.source });
}
