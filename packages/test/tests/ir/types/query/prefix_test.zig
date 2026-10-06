const std = @import("std");
const f = @import("fixture.zig");
const graph = @import("graph.zig");

fn noAllocation(table: f.ir.TypeTable, id: f.ir.TypeId, mode: f.Mode, expected: bool) !void {
    var failure = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });

    try std.testing.expectEqual(expected, try f.run(failure.allocator(), table, id, mode));
    try std.testing.expect(!failure.has_induced_failure);
    try std.testing.expectEqual(@as(usize, 0), failure.alloc_index);
}

fn family(tag: graph.Tag, mode: f.Mode, expected: bool) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try graph.build(arena.allocator());

    try noAllocation(value.storage.view(), value.id(tag), mode, expected);
}

test "all scalar roots return false without scanning targets later in the table" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const value = try graph.build(arena.allocator());

    for (std.enums.values(f.ir.Scalar)) |scalar| {
        try noAllocation(value.storage.view(), f.scalar(scalar), .native_reference, false);
        try noAllocation(value.storage.view(), f.scalar(scalar), .list, false);
    }
}

test "native root direct hit precedes flags allocation" {
    try family(.node, .native_reference, true);
}

test "list root direct hit precedes flags allocation" {
    try family(.numbers, .list, true);
}

test "late native direct hit ignores earlier targets without allocating" {
    try family(.late_node, .native_reference, true);
}

test "enum before the first target returns false without allocating" {
    try family(.mode, .native_reference, false);
    try family(.mode, .list, false);
}

test "optional scalar before the first target returns false without allocating" {
    try family(.plain_optional, .native_reference, false);
    try family(.plain_optional, .list, false);
}

test "native prefix does not count as a list target" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const memory = arena.allocator();
    var table = try f.base(memory);
    const node = try f.add(memory, &table, .{ .native_reference = "Node" });
    const root = try f.add(memory, &table, .{ .optional = node });

    try f.valid(table.view());
    try noAllocation(table.view(), root, .list, false);
    try std.testing.expect(try f.run(std.testing.allocator, table.view(), root, .native_reference));
}

test "list prefix does not count as a native reference target" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const memory = arena.allocator();
    var table = try f.base(memory);
    const numbers = try f.add(memory, &table, .{ .list = f.scalar(.u64) });
    const root = try f.add(memory, &table, .{ .optional = numbers });

    try f.valid(table.view());
    try noAllocation(table.view(), root, .native_reference, false);
    try std.testing.expect(try f.run(std.testing.allocator, table.view(), root, .list));
}

test "enum and error labels matching Node are not native type edges" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const memory = arena.allocator();
    var table = try f.base(memory);
    const enumeration = try f.add(memory, &table, .{ .enumeration = .{ .name = "Node", .members = &.{"List"} } });
    const errors = try f.add(memory, &table, .{ .error_set = &.{ "List", "Node" } });
    const task = try f.add(memory, &table, .{ .task = .{ .result = enumeration, .errors = errors } });

    try f.valid(table.view());
    try noAllocation(table.view(), task, .native_reference, false);
    try noAllocation(table.view(), task, .list, false);
}
