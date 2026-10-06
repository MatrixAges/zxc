const std = @import("std");
const f = @import("fixture.zig");
const check = @import("check.zig");
const cases = @import("cases.zig");

test "full graphs share all tags across shifted local ids" {
    try cases.two(.{}, .{ .noise = true }, .{}, cases.base_count + 2, 3);
}

test "reversed module order shares all tags across shifted local ids" {
    try cases.two(.{ .noise = true }, .{}, .{}, cases.base_count + 2, 3);
}

test "same source graph reuses duplicate nominal and structural rows" {
    try cases.two(.{ .aliases = true }, .{}, .{}, cases.base_count, 2);
}

test "noisy duplicate rows reuse later auxiliary ranges" {
    try cases.two(.{}, .{ .noise = true, .aliases = true }, .{}, cases.base_count + 2, 3);
}

test "both inputs containing duplicates produce only canonical rows" {
    try cases.two(.{ .aliases = true }, .{ .aliases = true }, .{}, cases.base_count, 2);
}

test "changed tuple tail separates tuple and all dependents" {
    try cases.two(.{}, .{ .change = .tuple_tail }, .{ .pair = false, .saved = false, .list = false, .record = false, .task = false }, cases.base_count + 5, 2);
}

test "changed final object name separates object and task" {
    try cases.two(.{}, .{ .change = .object_name }, .{ .record = false, .task = false }, cases.base_count + 2, 2);
}

test "changed final object type separates object and task" {
    try cases.two(.{}, .{ .change = .object_type }, .{ .record = false, .task = false }, cases.base_count + 2, 2);
}

test "changed later error name separates finite errors and task" {
    try cases.two(.{}, .{ .change = .errors }, .{ .errors = false, .task = false }, cases.base_count + 2, 2);
}

test "changed task result preserves every prerequisite row" {
    try cases.two(.{}, .{ .change = .task_result }, .{ .task = false }, cases.base_count + 1, 2);
}

test "changed task error set preserves every other source row" {
    try cases.two(.{}, .{ .change = .task_errors }, .{ .task = false }, cases.base_count + 2, 2);
}

test "list and optional with equal scalar child are distinct" {
    try cases.two(.{}, .{ .change = .plain_kind }, .{ .plain = false, .record = false, .task = false }, cases.base_count + 3, 2);
}

test "empty module set retains complete scalar prefix" {
    var result = try f.link.merge(std.testing.allocator, &.{});

    defer result.deinit();

    try std.testing.expectEqual(std.enums.values(f.ir.Scalar).len, result.types.count());
    try std.testing.expectEqual(@as(usize, 0), result.nominal_types.count());
    try std.testing.expectEqual(@as(usize, 0), result.mappings.len);
    for (std.enums.values(f.ir.Scalar), 0..) |value, index| try std.testing.expectEqual(value, result.types.at(index).scalar);
}

test "one full graph maps every local row identically" {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    const source = try f.source(memory.allocator(), .{});
    var result = try f.link.merge(std.testing.allocator, &.{source.module});

    defer result.deinit();

    _ = try check.module(result, source, 0);

    for (result.mappings[0], 0..) |id, index| try std.testing.expectEqual(@as(u32, @intCast(index)), @backingInt(id));
}

test "merged table can be remerged without appending or losing origins" {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    const source = try f.source(memory.allocator(), .{ .noise = true, .aliases = true });
    var first = try f.link.merge(std.testing.allocator, &.{source.module});

    defer first.deinit();

    var module = source.module;

    module.types = first.types;
    module.nominal_types = first.nominal_types;

    var second = try f.link.merge(std.testing.allocator, &.{ module, module });

    defer second.deinit();

    try std.testing.expectEqual(first.types.count(), second.types.count());
    try std.testing.expectEqual(first.nominal_types.count(), second.nominal_types.count());
    try f.sameColumns(first.types, second.types);
    try f.sameColumns(first.nominal_types, second.nominal_types);

    for (second.mappings) |mapping| {
        for (mapping, 0..) |id, index| try std.testing.expectEqual(@as(u32, @intCast(index)), @backingInt(id));
    }
}
