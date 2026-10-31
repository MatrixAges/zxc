const std = @import("std");

pub const Edit = struct {
    span: struct { start: usize, end: usize },
    replacement: []const u8,
};

pub fn resolve(source: []const u8, left: anytype, right: @TypeOf(left), preserve_trailing: bool) ?Edit {
    if (preserve_trailing) return null;

    var start = left.end;
    var end = right.start;
    var offset = start;
    var locked = false;

    while (offset < right.start) {
        const byte = source[offset];

        if (byte == '#') {
            const comment_end = std.mem.indexOfAnyPos(u8, source, offset, "\r\n") orelse source.len;

            if (!locked and comment_end <= right.start) {
                if (std.mem.indexOfScalar(u8, source[start..offset], '\n') == null) {
                    start = comment_end;
                } else {
                    end = offset;
                    locked = true;
                }
            }

            offset = comment_end;
        } else if (std.mem.indexOfScalar(u8, " \t\r\n", byte) != null) {
            offset += 1;
        } else {
            return null;
        }
    }

    const gap = source[start..end];
    const first = std.mem.indexOfScalar(u8, gap, '\n') orelse return null;
    const last = std.mem.lastIndexOfScalar(u8, gap, '\n').?;
    const crlf = first > 0 and gap[first - 1] == '\r';
    const separate = std.mem.indexOfScalar(u8, source[left.start..left.end], '\n') != null or std.mem.indexOfScalar(u8, source[right.start..right.end], '\n') != null;
    const replacement: []const u8 = if (crlf) (if (separate) "\r\n\r\n" else "\r\n") else (if (separate) "\n\n" else "\n");
    const newline_start = first - @intFromBool(crlf);

    if (std.mem.eql(u8, gap[newline_start .. last + 1], replacement)) return null;

    return .{
        .span = .{ .start = start + newline_start, .end = start + last + 1 },
        .replacement = replacement,
    };
}
