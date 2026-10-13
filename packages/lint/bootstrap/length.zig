const std = @import("std");
pub const default_maximum: usize = 120;
pub const Exceeded = struct { lines: usize, maximum: usize };

pub fn check(text: []const u8, maximum: usize) ?Exceeded {
    if (maximum == 0) return null;

    const lines = count(text);

    return if (lines > maximum) .{ .lines = lines, .maximum = maximum } else null;
}

pub fn count(text: []const u8) usize {
    if (text.len == 0) return 0;

    return std.mem.countScalar(u8, text, '\n') + @intFromBool(text[text.len - 1] != '\n');
}
