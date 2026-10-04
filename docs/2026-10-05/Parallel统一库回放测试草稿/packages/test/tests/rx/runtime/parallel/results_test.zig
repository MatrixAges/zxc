const std = @import("std");
const program = @import("program");

fn check(allocator: std.mem.Allocator, input: []const u64) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const before = try std.testing.allocator.dupe(u64, input);

    defer std.testing.allocator.free(before);

    const output = program.execute(&arena, input) catch |err| {
        try std.testing.expectEqualSlices(u64, before, input);

        return err;
    };

    try std.testing.expectEqual(input.len, output.left.len);
    try std.testing.expectEqual(input.len, output.right.len);

    for (before, output.left, output.right) |original, left, right| {
        try std.testing.expectEqual(original + 1, left);
        try std.testing.expectEqual(original * 2, right);
    }

    try std.testing.expectEqualSlices(u64, before, input);

    if (input.len != 0) {
        try std.testing.expect(output.left.ptr != output.right.ptr);
        try std.testing.expect(output.left.ptr != input.ptr);
        try std.testing.expect(output.right.ptr != input.ptr);
    }
}

test "RX parallel empty outputs survive join" {
    try check(std.testing.allocator, &.{});
}

test "RX parallel singleton results stay independent" {
    try check(std.testing.allocator, &.{7});
}

test "RX parallel results retain list order and zero" {
    try check(std.testing.allocator, &.{ 13, 0, 3, 2, 13 });
}

test "RX parallel results preserve exact safe integer boundary" {
    try check(std.testing.allocator, &.{ 0, std.math.maxInt(u64) / 2 });
}

test "RX parallel repeated requests keep previous output alive" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = try program.execute(&arena, &.{ 3, 5 });
    const second = try program.execute(&arena, &.{ 7, 11 });

    try std.testing.expectEqualSlices(u64, &.{ 4, 6 }, first.left);
    try std.testing.expectEqualSlices(u64, &.{ 6, 10 }, first.right);
    try std.testing.expectEqualSlices(u64, &.{ 8, 12 }, second.left);
    try std.testing.expectEqualSlices(u64, &.{ 14, 22 }, second.right);
}

test "RX parallel allocation failure frees all request storage" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{@as([]const u64, &.{ 2, 7, 11 })});
}
