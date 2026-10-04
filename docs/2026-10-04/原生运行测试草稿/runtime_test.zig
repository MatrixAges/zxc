const std = @import("std");
const program = @import("program");
const host = @import("host");

test "First traverses helper and entry native calls in order" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    host.reset(0);

    try std.testing.expectEqual(host.Mode.First, try program.execute(&arena, host.Mode.First));
    try std.testing.expectEqual(@as(usize, 2), host.calls);
    try std.testing.expectEqualSlices(host.Mode, &.{ .First, .Second }, &host.trace);
}

test "Second traverses helper and entry native calls in order" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    host.reset(0);

    try std.testing.expectEqual(host.Mode.Second, try program.execute(&arena, host.Mode.Second));
    try std.testing.expectEqual(@as(usize, 2), host.calls);
    try std.testing.expectEqualSlices(host.Mode, &.{ .Second, .First }, &host.trace);
}

test "helper native failure prevents entry native call" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    host.reset(1);

    try std.testing.expectError(error.NativeFailure, program.execute(&arena, host.Mode.First));
    try std.testing.expectEqual(@as(usize, 1), host.calls);
    try std.testing.expectEqual(host.Mode.First, host.trace[0]);
}

test "entry native failure preserves completed helper call" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    host.reset(2);

    try std.testing.expectError(error.NativeFailure, program.execute(&arena, host.Mode.Second));
    try std.testing.expectEqual(@as(usize, 2), host.calls);
    try std.testing.expectEqualSlices(host.Mode, &.{ .Second, .First }, &host.trace);
}
