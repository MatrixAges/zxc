const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");

test "present native reference skips the fallback accessor" {
    const selected = host.HostNode{ .value = 9 };
    const fallback = host.HostNode{ .value = 9 };
    const input: @typeInfo(program.Input).pointer.child = .{ .selected = host.fromNode(&selected), .fallback = host.fromNode(&fallback) };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset(0);

    try support.expectNode(&selected, try program.execute(&arena, &input));
    try std.testing.expectEqual(@as(usize, 0), host.calls);
}

test "null native reference invokes only the fallback accessor" {
    const fallback = host.HostNode{ .value = 9 };
    const input: @typeInfo(program.Input).pointer.child = .{ .selected = null, .fallback = host.fromNode(&fallback) };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset(0);

    try support.expectNode(&fallback, try program.execute(&arena, &input));
    try std.testing.expectEqual(@as(usize, 1), host.calls);
    try support.expectNode(&fallback, host.events[0].node);
}
