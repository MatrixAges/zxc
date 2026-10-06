const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");

fn execute(failure: usize) !void {
    const left = host.HostNode{ .value = 7, .payload = "left" };
    const right = host.HostNode{ .value = 7, .payload = "right" };
    const input: @typeInfo(program.Input).pointer.child = .{ .left = host.fromNode(&left), .right = host.fromNode(&right) };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset(failure);

    if (failure == 0) {
        const result = try program.execute(&arena, &input);

        try support.expectNode(&left, result[0]);
        try support.expectNode(&right, result[1]);
        try std.testing.expectEqual(@as(u64, 7), result[2]);
        try std.testing.expectEqual(@as(usize, 3), host.calls);
        try support.expectNode(&left, host.events[2].node);
        try std.testing.expectEqual(@as(u64, 2), host.events[2].marker);
    } else {
        try std.testing.expectError(error.NativeFailure, program.execute(&arena, &input));
        try std.testing.expectEqual(failure, host.calls);
    }

    try support.expectNode(&left, host.events[0].node);
    try std.testing.expectEqual(@as(u64, 1), host.events[0].marker);

    if (failure != 1) {
        try support.expectNode(&right, host.events[1].node);
        try std.testing.expectEqual(@as(u64, 2), host.events[1].marker);
    }

    try support.expectOwner(.{ .value = 7, .payload = "left" }, left);
    try support.expectOwner(.{ .value = 7, .payload = "right" }, right);
}

test "native reference argument expansion preserves address order across equal valued owners" {
    try execute(0);
}

test "first native reference error prevents all later native calls" {
    try execute(1);
}

test "second native reference error preserves the first call and skips the read" {
    try execute(2);
}
