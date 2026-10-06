const std = @import("std");
const program = @import("program");
const host = @import("host");
const support = @import("reference_support");

test "native optional reference returns the address of the owner's actual child" {
    const children = [_]host.HostNode{.{ .value = 42, .payload = "child" }};
    const owner = host.HostNode{ .value = 42, .children = &children };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset(0);

    const result = (try program.execute(&arena, host.fromNode(&owner))).?;

    try support.expectNode(&children[0], result);
    try support.expectOwner(.{ .value = 42, .children = &children }, owner);
}

test "native optional reference represents a missing child as null" {
    const owner = host.HostNode{ .value = 9 };
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset(0);

    try std.testing.expectEqual(@as(program.Output, null), try program.execute(&arena, host.fromNode(&owner)));
    try std.testing.expectEqual(@as(usize, 1), host.calls);
    try support.expectOwner(.{ .value = 9 }, owner);
}
