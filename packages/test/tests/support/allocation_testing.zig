const std = @import("std");

pub fn checkAllAllocationFailures(backing_allocator: std.mem.Allocator, comptime test_fn: anytype, extra_args: anytype) !void {
    var vtable = backing_allocator.vtable.*;
    vtable.resize = std.mem.Allocator.noResize;
    vtable.remap = std.mem.Allocator.noRemap;
    const allocator: std.mem.Allocator = .{ .ptr = backing_allocator.ptr, .vtable = &vtable };
    const Errors = @typeInfo(@typeInfo(@TypeOf(test_fn)).@"fn".return_type.?).error_union.error_set;

    const Checked = struct {
        fn run(memory: std.mem.Allocator, args: @TypeOf(extra_args)) (Errors || std.mem.Allocator.Error)!void {
            try @call(.auto, test_fn, .{memory} ++ args);
        }
    };

    try std.testing.checkAllAllocationFailures(allocator, Checked.run, .{extra_args});
}
