const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");

test "native reference identity preserves the actual host address and complete contents" {
    const children = [_]host.HostNode{.{ .value = 9, .payload = "child" }};
    const owner = host.HostNode{ .value = 42, .payload = "owner", .children = &children };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset(0);

    const result = try program.execute(&arena, host.fromNode(&owner));

    try support.expectNode(&owner, result);
    try support.expectOwner(.{ .value = 42, .payload = "owner", .children = &children }, owner);
    try std.testing.expectEqual(@as(usize, 1), host.calls);
    try support.expectNode(&owner, host.events[0].node);
}

test "native reference identity can execute with no allocation capacity" {
    const owner = host.HostNode{ .value = 7 };
    var buffer = std.heap.FixedBufferAllocator.init(&.{});
    var arena = std.heap.ArenaAllocator.init(buffer.allocator());

    defer arena.deinit();
    host.reset(0);

    try support.expectNode(&owner, try program.execute(&arena, host.fromNode(&owner)));
}
