const std = @import("std");

pub fn checkAllAllocationFailures(backing_allocator: std.mem.Allocator, comptime test_fn: anytype, extra_args: anytype) !void {
    var vtable = backing_allocator.vtable.*;
    vtable.resize = std.mem.Allocator.noResize;
    vtable.remap = std.mem.Allocator.noRemap;
    const allocator: std.mem.Allocator = .{ .ptr = backing_allocator.ptr, .vtable = &vtable };

    try std.testing.checkAllAllocationFailures(allocator, test_fn, extra_args);
}
