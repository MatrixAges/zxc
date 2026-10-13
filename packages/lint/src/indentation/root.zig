const std = @import("std");
const Edit = @import("../spacing.zig").Edit;
const line_rule = @import("indentation_line");
pub const width = 4;
pub const zx = @import("zx.zig");

pub fn line(allocator: std.mem.Allocator, source: []const u8, offset: usize, level: usize) std.mem.Allocator.Error!?Edit {
    const planned = line_rule.plan(source, offset, level) orelse return null;
    const replacement = try allocator.alloc(u8, planned.count);

    @memset(replacement, ' ');

    return .{ .span = .{ .start = planned.start, .end = planned.end }, .replacement = replacement };
}
