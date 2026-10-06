const std = @import("std");
const compiler = @import("compiler");
const allocation_testing = @import("allocation_testing");
const ir = compiler.ir;
const scalar_count = @typeInfo(ir.Scalar).@"enum".field_names.len;

fn composite(storage: *ir.TypeStorage, allocator: std.mem.Allocator) !void {
    const u64_id: ir.TypeId = @fromBackingInt(@intCast(@backingInt(ir.Scalar.u64)));
    const bool_id: ir.TypeId = @fromBackingInt(@intCast(@backingInt(ir.Scalar.bool)));
    const pair: ir.TypeId = @fromBackingInt(@intCast(storage.count()));

    try storage.append(allocator, .{ .tuple = &.{ u64_id, bool_id } });

    const saved: ir.TypeId = @fromBackingInt(@intCast(storage.count()));

    try storage.append(allocator, .{ .optional = u64_id });

    const record: ir.TypeId = @fromBackingInt(@intCast(storage.count()));

    try storage.append(allocator, .{ .object = .{ .names = &.{ "pair", "saved" }, .types = &.{ @backingInt(pair), @backingInt(saved) }, .len = 2 } });
    try storage.append(allocator, .{ .list = record });

    const errors: ir.TypeId = @fromBackingInt(@intCast(storage.count()));

    try storage.append(allocator, .{ .error_set = &.{"Failure"} });
    try storage.append(allocator, .{ .enumeration = .{ .name = "Mode", .members = &.{ "First", "Second" } } });
    try storage.append(allocator, .{ .native_reference = "Node" });
    try storage.append(allocator, .{ .task = .{ .result = record, .errors = errors } });
}

fn finish(allocator: std.mem.Allocator, with_composite: bool) !void {
    var storage: ir.TypeStorage = .{};

    defer storage.deinit(allocator);

    inline for (@typeInfo(ir.Scalar).@"enum".field_names) |name| {
        try storage.append(allocator, .{ .scalar = @field(ir.Scalar, name) });
    }

    if (with_composite) try composite(&storage, allocator);

    const table = try storage.finish(allocator);

    defer {
        inline for (@typeInfo(ir.TypeTable).@"struct".field_names) |name| {
            allocator.free(@field(table, name));
        }
    }

    try std.testing.expect(table.validStructure());
    try std.testing.expectEqual(@as(usize, 0), storage.count());
    try std.testing.expectEqual(scalar_count + @as(usize, if (with_composite) 8 else 0), table.count());

    inline for (@typeInfo(ir.Scalar).@"enum".field_names, 0..) |name, index| {
        try std.testing.expectEqual(@field(ir.Scalar, name), table.at(index).scalar);
    }

    if (with_composite) {
        try std.testing.expectEqualSlices(u32, &.{ @backingInt(ir.Scalar.u64), @backingInt(ir.Scalar.bool) }, table.children);
        try std.testing.expectEqualSlices(u32, &.{ scalar_count, scalar_count + 1 }, table.field_types);
        try std.testing.expectEqualStrings("pair", table.field_names[0]);
        try std.testing.expectEqualStrings("saved", table.field_names[1]);
        try std.testing.expectEqualStrings("Failure", table.names[0]);
        try std.testing.expectEqualStrings("First", table.names[1]);
        try std.testing.expectEqualStrings("Second", table.names[2]);
        try std.testing.expectEqualStrings("Mode", table.at(scalar_count + 5).enumeration.name);
        try std.testing.expectEqualStrings("Node", table.at(scalar_count + 6).native_reference);
        try std.testing.expectEqual(@as(u32, @backingInt(ir.Scalar.u64)), @backingInt(table.at(scalar_count + 1).optional));
        try std.testing.expectEqual(@as(u32, scalar_count + 2), @backingInt(table.at(scalar_count + 3).list));
        try std.testing.expectEqual(@as(u32, scalar_count + 2), @backingInt(table.at(scalar_count + 7).task.result));
        try std.testing.expectEqual(@as(u32, scalar_count + 4), @backingInt(table.at(scalar_count + 7).task.errors));
    }
}

test "scalar type storage finish cleans every partial ownership transfer" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, finish, .{false});
}

test "all type table columns survive finish and release every failed transfer" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, finish, .{true});
}
