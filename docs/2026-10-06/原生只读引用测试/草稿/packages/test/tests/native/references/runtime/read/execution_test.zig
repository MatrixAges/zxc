const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");

test "native accessor reads the real host field without changing the owner" {
    const owner = host.HostNode{ .value = 42, .payload = "value" };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset(0);

    try std.testing.expectEqual(@as(u64, 42), try program.execute(&arena, host.fromNode(&owner)));
    try support.expectOwner(.{ .value = 42, .payload = "value" }, owner);
    try support.expectNode(&owner, host.events[0].node);
}

test "native accessor preserves a zero field with no allocation capacity" {
    const owner = host.HostNode{ .value = 0 };
    var buffer = std.heap.FixedBufferAllocator.init(&.{});
    var arena = std.heap.ArenaAllocator.init(buffer.allocator());

    defer arena.deinit();
    host.reset(0);

    try std.testing.expectEqual(@as(u64, 0), try program.execute(&arena, host.fromNode(&owner)));
    try support.expectNode(&owner, host.events[0].node);
}
