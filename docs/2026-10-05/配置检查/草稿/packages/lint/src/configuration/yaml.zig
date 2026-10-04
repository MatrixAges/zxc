const std = @import("std");
const zx = @import("zx");
const spacing = @import("../spacing.zig");
const shape = @import("../shape.zig");

pub const Field = struct { span: zx.Span, preserve_trailing: bool };

pub fn format(allocator: std.mem.Allocator, source: []const u8, fields: []const Field) std.mem.Allocator.Error![]u8 {
    if (fields.len < 2) return allocator.dupe(u8, source);

    var edits: std.ArrayList(spacing.Edit) = .empty;
    var comments: std.ArrayList(zx.Span) = .empty;

    defer edits.deinit(allocator);
    defer comments.deinit(allocator);

    for (fields[0 .. fields.len - 1], fields[1..]) |left, right| {
        if (left.preserve_trailing) continue;

        comments.clearRetainingCapacity();

        var offset = left.span.end;
        var whitespace_only = true;

        while (offset < right.span.start) {
            const byte = source[offset];

            if (byte == '#') {
                const end = std.mem.indexOfAnyPos(u8, source, offset, "\r\n") orelse source.len;

                try comments.append(allocator, .{ .start = offset, .end = end });

                offset = end;
            } else if (std.mem.indexOfScalar(u8, " \t\r\n", byte) != null) {
                offset += 1;
            } else {
                whitespace_only = false;

                break;
            }
        }

        if (!whitespace_only) continue;

        const separate = shape.multiline(source, left.span) or shape.multiline(source, right.span);

        if (spacing.boundary(source, comments.items, left.span.end, right.span.start, separate)) |edit| try edits.append(allocator, edit);
    }

    return spacing.format(allocator, source, edits.items);
}
