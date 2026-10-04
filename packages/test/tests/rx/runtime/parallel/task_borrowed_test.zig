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
        try std.testing.expectEqual(original + 2, right);
    }

    try std.testing.expectEqualSlices(u64, before, input);

    if (input.len != 0) {
        try std.testing.expect(output.left.ptr != input.ptr);
        try std.testing.expect(output.right.ptr != output.left.ptr);
    }
}

test "RX Task returned captured empty list survives environment teardown" {
    try check(std.testing.allocator, &.{});
}

test "RX Task returned captured singleton survives environment teardown" {
    try check(std.testing.allocator, &.{13});
}

test "RX Task captured owned list and newly allocated sibling remain distinct" {
    try check(std.testing.allocator, &.{ 3, 0, 5, 3 });
}

test "RX Task captured owned list retains u64 boundary after join" {
    try check(std.testing.allocator, &.{ 0, std.math.maxInt(u64) - 2 });
}

test "RX Task captured owned list cleans every allocation failure" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{@as([]const u64, &.{ 2, 7, 11 })});
}

test "RX Task prior captured output remains alive across another request" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = try program.execute(&arena, &.{ 2, 5 });
    const second = try program.execute(&arena, &.{ 7, 11 });

    try std.testing.expectEqualSlices(u64, &.{ 3, 6 }, first.left);
    try std.testing.expectEqualSlices(u64, &.{ 4, 7 }, first.right);
    try std.testing.expectEqualSlices(u64, &.{ 8, 12 }, second.left);
    try std.testing.expectEqualSlices(u64, &.{ 9, 13 }, second.right);
}
