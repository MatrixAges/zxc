const std = @import("std");
const Edit = @import("../spacing.zig").Edit;
pub const width = 4;
pub const zx = @import("zx.zig");

pub fn line(allocator: std.mem.Allocator, source: []const u8, offset: usize, level: usize) std.mem.Allocator.Error!?Edit {
    var start = offset;

    while (start > 0 and (source[start - 1] == ' ' or source[start - 1] == '\t')) start -= 1;
    if (start > 0 and source[start - 1] != '\n') return null;

    const count = level * width;
    const previous = source[start..offset];

    if (previous.len == count and std.mem.indexOfScalar(u8, previous, '\t') == null) return null;

    const replacement = try allocator.alloc(u8, count);

    @memset(replacement, ' ');

    return .{ .span = .{ .start = start, .end = offset }, .replacement = replacement };
}
