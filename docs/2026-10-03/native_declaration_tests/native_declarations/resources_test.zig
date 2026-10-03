const std = @import("std");
const library = @import("library");
const Item = @typeInfo(@FieldType(library.Input, "items")).pointer.child;
const Snapshot = @typeInfo(@FieldType(library.Input, "baseline")).pointer.child;

fn checkSuccess(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = try library.execute(&arena, .{
        .items = &[_]Item{ .{ .value = -12 }, .{ .value = 7 } },
        .baseline = &[_]Snapshot{.{ .value = 91 }},
        .offset = 3,
        .mode = .Add,
    });

    try std.testing.expectEqual(@as(usize, 2), output.items.len);
    try std.testing.expectEqual(@as(i32, -9), output.items[0].value);
    try std.testing.expectEqual(@as(i32, 10), output.items[1].value);
    try std.testing.expectEqual(@as(usize, 1), output.baseline.len);
    try std.testing.expectEqual(@as(i32, 91), output.baseline[0].value);
    try std.testing.expect(output.mode == .Add);
}

fn checkFailure(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const output = library.execute(&arena, .{
        .items = &[_]Item{.{ .value = 1 }},
        .baseline = &[_]Snapshot{.{ .value = 2 }},
        .offset = -1,
        .mode = .Add,
    }) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.NegativeOffset, err);

        return;
    };

    _ = output;

    return error.ExpectedNativeFailure;
}

test "native aggregate conversion releases all arena allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{});
}

test "native error releases all arena allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{});
}
