const std = @import("std");
const allocation_testing = @import("allocation_testing");
const rx = @import("rx");
const analysis = @import("rx_analysis");
const compiler = @import("compiler");
const Mode = enum { success, setter, duplicate };

fn infer(allocator: std.mem.Allocator, mode: Mode) !analysis.module.Result {
    var inputs = std.heap.ArenaAllocator.init(allocator);

    defer inputs.deinit();

    const input = inputs.allocator();

    const source = try input.dupe(u8, if (mode == .setter)
        "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs.counter.value]}/></Module>"
    else
        "<Module><Store from='state' as='jobs'/><Call fn='write' in={1} setter={[store.jobs.counter]}/><Return value={$ctx.write}/></Module>");

    var main = try rx.parseXml(input, source);

    defer main.deinit();

    var state = try rx.parseXml(input, try input.dupe(u8, @embedFile("fixtures/state.store.rx")));

    defer state.deinit();

    try std.testing.expect(main.value == .node and state.value == .node);

    const stores = [_]rx.ModuleSource{
        .{ .path = try input.dupe(u8, "state.store.rx"), .node = state.value.node },
        .{ .path = try input.dupe(u8, "./state.store.rx"), .node = state.value.node },
    };

    return analysis.project.infer(allocator, .{
        .entry = try input.dupe(u8, "main.rx"),
        .modules = &.{.{ .path = try input.dupe(u8, "main.rx"), .node = main.value.node }},
        .stores = stores[0..if (mode == .duplicate) @as(usize, 2) else 1],
        .sources = &.{.{ .path = try input.dupe(u8, "write.zx"), .source = try input.dupe(u8, @embedFile("fixtures/write.zx")) }},
    });
}

fn check(allocator: std.mem.Allocator, mode: Mode) !void {
    var result = try infer(allocator, mode);

    defer result.deinit();

    if (mode != .success) {
        try std.testing.expect(result.value == .diagnostic);

        const issue = result.value.diagnostic;

        try std.testing.expectEqualStrings(if (mode == .setter) "capability" else "module", issue.code);
        try std.testing.expectEqualStrings(if (mode == .setter) "main.rx" else "./state.store.rx", issue.path);
        try std.testing.expect(issue.message.len != 0);
        try std.testing.expectEqual(@as(usize, 1), issue.location.line);

        return;
    }

    try std.testing.expect(result.value == .contract);

    const contract = result.value.contract;

    try std.testing.expectEqual(@as(usize, 1), contract.program.stores.count());
    try std.testing.expectEqualStrings("store.state.store.rx:counter", contract.program.stores.at(0).path);
    try std.testing.expectEqual(@as(usize, 1), contract.store_definitions.len);

    const definition = contract.store_definitions[0];

    try std.testing.expectEqualStrings("state.store.rx", definition.source_path);
    try std.testing.expectEqualStrings("counter_state", definition.name);
    try std.testing.expectEqual(@as(u32, 1), definition.version);
    try std.testing.expectEqual(@as(usize, 1), definition.objects.len);
    try std.testing.expectEqualStrings("counter", definition.objects[0].name);

    for ([_]@TypeOf(contract.program){ contract.program, definition.objects[0].initial }) |program| {
        try std.testing.expect(try compiler.validateIr(allocator, program) == null);

        const bundle = try compiler.zig.emitBundle(allocator, program);

        defer bundle.deinit(allocator);

        try std.testing.expect(bundle.source.len != 0);
        try std.testing.expect(bundle.types.len != 0);
    }
}

test "RX Store contract survives released input arenas" {
    try check(std.testing.allocator, .success);
}

test "RX Store setter diagnostic survives released input arenas" {
    try check(std.testing.allocator, .setter);
}

test "RX duplicate Store diagnostic survives released input arenas" {
    try check(std.testing.allocator, .duplicate);
}

test "RX Store detached contract allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.success});
}

test "RX Store detached setter diagnostic allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.setter});
}

test "RX Store detached duplicate diagnostic allocation failures" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{Mode.duplicate});
}
