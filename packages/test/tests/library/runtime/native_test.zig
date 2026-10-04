const std = @import("std");
const alpha = @import("alpha");
const beta = @import("beta");
const repeated = @import("repeat");
const host = @import("host");

test "native unified public entries share enum identity and host state" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    for ([_]host.Mode{ .First, .Second }) |input| {
        host.reset(0);
        try std.testing.expectEqual(input, try alpha.execute(&arena, input));
        try std.testing.expectEqual(@as(usize, 2), host.calls);
        try std.testing.expectEqual(input, host.trace[0]);
        try std.testing.expect(host.trace[1] != input);

        host.reset(0);
        const flipped = try beta.execute(&arena, input);
        try std.testing.expect(flipped != input);
        try std.testing.expectEqual(@as(usize, 1), host.calls);

        host.reset(0);
        try std.testing.expectEqual(flipped, try repeated.execute(&arena, flipped));
        try std.testing.expectEqual(@as(usize, 2), host.calls);
    }
}

test "native unified entry propagates helper and caller failures in order" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    for ([_]usize{ 1, 2 }) |failure| {
        host.reset(failure);
        try std.testing.expectError(error.NativeFailure, alpha.execute(&arena, host.Mode.First));
        try std.testing.expectEqual(failure, host.calls);
        try std.testing.expectEqual(host.Mode.First, host.trace[0]);
        if (failure == 2) try std.testing.expectEqual(host.Mode.Second, host.trace[1]);
    }
}

test "native public helper and repeated entry preserve error behavior" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();

    host.reset(1);
    try std.testing.expectError(error.NativeFailure, beta.execute(&arena, host.Mode.Second));
    try std.testing.expectEqual(@as(usize, 1), host.calls);
    try std.testing.expectEqual(host.Mode.Second, host.trace[0]);

    host.reset(2);
    try std.testing.expectError(error.NativeFailure, repeated.execute(&arena, host.Mode.Second));
    try std.testing.expectEqualSlices(host.Mode, &.{ .Second, .First }, &host.trace);
    try std.testing.expectEqual(@as(usize, 2), host.calls);
}
