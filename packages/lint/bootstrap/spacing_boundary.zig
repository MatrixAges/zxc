const std = @import("std");

pub const Edit = struct {
    span: struct { start: usize, end: usize },
    replacement: []const u8,
};

pub fn resolve(source: []const u8, start: usize, end: usize, separate: bool) ?Edit {
    const gap = source[start..end];
    const first = std.mem.indexOfScalar(u8, gap, '\n') orelse return null;
    const last = std.mem.lastIndexOfScalar(u8, gap, '\n').?;
    const crlf = first > 0 and gap[first - 1] == '\r';
    const newline_start = first - @intFromBool(crlf);
    const replacement: []const u8 = if (crlf) (if (separate) "\r\n\r\n" else "\r\n") else (if (separate) "\n\n" else "\n");
    const old = gap[newline_start .. last + 1];

    if (std.mem.eql(u8, old, replacement)) return null;

    return .{
        .span = .{ .start = start + newline_start, .end = start + last + 1 },
        .replacement = replacement,
    };
}
