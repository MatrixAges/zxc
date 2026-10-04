const std = @import("std");
const program = @import("program");
const options = @import("options");
const Tracking = @import("tracking.zig");

fn check() !void {
    var input: [8192]u64 = undefined;

    for (&input, 0..) |*value, index| value.* = index;

    var tracking = Tracking{ .child = std.testing.allocator };
    var arena = std.heap.ArenaAllocator.init(tracking.allocator());

    defer arena.deinit();

    const output = try program.execute(&arena, &input);

    try std.testing.expectEqualSlices(u64, &input, output.left);
    try std.testing.expectEqualSlices(u64, &input, output.right);
    try std.testing.expect(output.left.ptr != input[0..].ptr);
    try std.testing.expect(output.right.ptr != input[0..].ptr);
    try std.testing.expect(output.left.ptr != output.right.ptr);

    if (options.nested) {
        try std.testing.expect(tracking.workers() >= 2);
    } else try std.testing.expectEqual(@as(usize, 2), tracking.workers());

    for (input, 0..) |value, index| try std.testing.expectEqual(index, value);
}

test "RX parallel single-copy branches allocate on distinct worker threads" {
    for (0..32) |_| try check();
}
