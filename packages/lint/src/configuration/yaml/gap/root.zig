const std = @import("std");
const generated = @import("generated");

pub const Edit = struct {
    span: struct { start: usize, end: usize },
    replacement: []const u8,
};

pub fn resolve(source: []const u8, left: anytype, right: @TypeOf(left), preserve_trailing: bool) ?Edit {
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);

    const output = generated.executeValue(fixed.allocator(), &.{
        .gap = source[left.end..right.start],
        .left = source[left.start..left.end],
        .right = source[right.start..right.end],
        .preserve_trailing = preserve_trailing,
    }) catch unreachable;

    if (!output.needs_edit) return null;

    const replacement: []const u8 = if (output.crlf)
        (if (output.separate) "\r\n\r\n" else "\r\n")

    else
        (if (output.separate) "\n\n" else "\n");

    return .{
        .span = .{ .start = left.end + @as(usize, @intCast(output.start)), .end = left.end + @as(usize, @intCast(output.end)) },
        .replacement = replacement,
    };
}
