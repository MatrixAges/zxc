const std = @import("std");
const program = @import("program");
const options = @import("options");
const Tracking = @import("tracking.zig");

fn check(allocator: std.mem.Allocator, missing: []const u64, expected: ?anyerror) !void {
    var input_values: [8192]u64 = undefined;

    for (&input_values, 0..) |*value, index| value.* = index;

    const input: std.meta.Child(program.Input) = .{ .values = &input_values, .missing = missing };
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    if (expected) |err| {
        try std.testing.expectError(err, program.execute(&arena, &input));
    } else {
        const output = try program.execute(&arena, &input);

        try std.testing.expectEqual(input_values.len, output.len);
        for (output, 0..) |value, index| try std.testing.expectEqual(index + 1, value);
    }

    for (input_values, 0..) |value, index| try std.testing.expectEqual(index, value);
}

test "RX parallel discarded branch error propagates after allocating sibling runs" {
    var tracking = Tracking{ .child = std.testing.allocator };

    try check(tracking.allocator(), &.{}, error.IndexOutOfBounds);
    try std.testing.expectEqual(@as(usize, 1), tracking.workers());
}

test "RX parallel discarded successful branch does not change returned sibling" {
    try check(std.testing.allocator, &.{23}, null);
}

test "RX parallel selects simultaneous errors in declaration order" {
    var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });
    var tracking = Tracking{ .child = failing.allocator() };

    try check(tracking.allocator(), &.{}, if (options.allocation_first) error.OutOfMemory else error.IndexOutOfBounds);
    try std.testing.expect(failing.has_induced_failure);
    try std.testing.expectEqual(@as(usize, 1), tracking.workers());
}

test "RX parallel allocation error propagates past successful discarded sibling" {
    var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });

    try check(failing.allocator(), &.{23}, error.OutOfMemory);
    try std.testing.expect(failing.has_induced_failure);
}

test "RX parallel later request succeeds after failed request arena is released" {
    try check(std.testing.allocator, &.{}, error.IndexOutOfBounds);
    try check(std.testing.allocator, &.{7}, null);
}
