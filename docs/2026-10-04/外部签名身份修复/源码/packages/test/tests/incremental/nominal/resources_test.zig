const std = @import("std");
const h = @import("check.zig");

test "native enum metadata cleans allocation failures across repeated imports" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, nativeTrace, .{});
}

test "legacy enum metadata cleans allocation failures across members and bindings" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, legacyTrace, .{});
}

fn nativeTrace(allocator: std.mem.Allocator) !void {
    var result = try h.native(allocator, false);

    defer result.deinit();

    try h.check(result, 1);
}

fn legacyTrace(allocator: std.mem.Allocator) !void {
    var result = try h.legacy(allocator, true);

    defer result.deinit();

    try h.check(result, 2);
}
