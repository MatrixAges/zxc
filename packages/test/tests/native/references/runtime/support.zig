const std = @import("std");
const host = @import("host");

pub fn expectNode(expected: *const host.HostNode, actual: host.Node) !void {
    try std.testing.expectEqual(@intFromPtr(expected), @intFromPtr(actual));
}

pub fn expectOwner(expected: host.HostNode, actual: host.HostNode) !void {
    try std.testing.expectEqual(expected.value, actual.value);
    try std.testing.expectEqualStrings(expected.payload, actual.payload);
    try std.testing.expectEqual(@intFromPtr(expected.payload.ptr), @intFromPtr(actual.payload.ptr));
    try std.testing.expectEqual(@intFromPtr(expected.children.ptr), @intFromPtr(actual.children.ptr));
    try std.testing.expectEqualDeep(expected.children, actual.children);
}
