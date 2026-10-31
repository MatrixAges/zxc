const std = @import("std");
const zx = @import("zx");
const spacing = @import("../spacing.zig");

pub const Field = struct { span: zx.Span, preserve_trailing: bool };

pub fn format(allocator: std.mem.Allocator, source: []const u8, fields: []const Field) std.mem.Allocator.Error![]u8 {
    if (fields.len < 2) return allocator.dupe(u8, source);

    var edits: std.ArrayList(spacing.Edit) = .empty;

    defer edits.deinit(allocator);

    for (fields[0 .. fields.len - 1], fields[1..]) |left, right| {
        if (@import("yaml_gap").resolve(source, left.span, right.span, left.preserve_trailing)) |edit| {
            try edits.append(allocator, .{
                .span = .{ .start = edit.span.start, .end = edit.span.end },
                .replacement = edit.replacement,
            });
        }
    }

    return spacing.format(allocator, source, edits.items);
}
