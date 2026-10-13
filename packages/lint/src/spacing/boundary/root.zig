const std = @import("std");
const generated = @import("generated");

pub const Edit = struct {
    span: struct { start: usize, end: usize },
    replacement: []const u8,
};

pub fn resolve(source: []const u8, start: usize, end: usize, separate: bool) ?Edit {
    var storage: [256]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);

    const output = generated.executeIn(fixed.allocator(), &.{
        .gap = source[start..end],
        .start = start,
        .separate = separate,
    }) catch unreachable;

    if (!output.needs_edit) return null;

    const replacement: []const u8 = if (output.crlf)
        (if (output.separate) "\r\n\r\n" else "\r\n")

    else
        (if (output.separate) "\n\n" else "\n");

    return .{
        .span = .{ .start = @intCast(output.start), .end = @intCast(output.end) },
        .replacement = replacement,
    };
}
