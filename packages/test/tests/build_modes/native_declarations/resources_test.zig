const std = @import("std");
const library = @import("library");

fn checkSuccess(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const input: library.Input = &.{
        .items = &.{ &.{ .value = -12 }, &.{ .value = 7 } },
        .baseline = &.{&.{ .value = 91 }},
        .offset = 3,
        .mode = .Add,
    };

    const output = try library.execute(&arena, input);

    try std.testing.expectEqual(input.baseline.ptr, output.baseline.ptr);
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

    const output = library.execute(&arena, &.{
        .items = &.{&.{ .value = 1 }},
        .baseline = &.{&.{ .value = 2 }},
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

test "native aggregate references preserve borrowed storage and release arena allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkSuccess, .{});
}

test "native error releases all arena allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, checkFailure, .{});
}
