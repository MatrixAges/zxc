const std = @import("std");

pub fn convert(allocator: std.mem.Allocator, source: []const u8, parts: anytype, value: anytype) ![]const u8 {
    if (value.head == 0) return source[@intCast(value.span.start)..@intCast(value.span.end)];

    var head = value.head;
    var length: usize = 0;

    while (head != 0) {
        const part = parts[@intCast(head - 1)];
        length += if (part.character) std.unicode.utf8CodepointSequenceLength(@intCast(part.codepoint)) catch unreachable else @as(usize, @intCast(part.span.end - part.span.start));
        head = part.previous;
    }

    const output = try allocator.alloc(u8, length);

    head = value.head;

    while (head != 0) {
        const part = parts[@intCast(head - 1)];
        var buffer: [4]u8 = undefined;
        const bytes = if (part.character) buffer[0 .. std.unicode.utf8Encode(@intCast(part.codepoint), &buffer) catch unreachable] else source[@intCast(part.span.start)..@intCast(part.span.end)];

        length -= bytes.len;

        @memcpy(output[length..][0..bytes.len], bytes);

        head = part.previous;
    }

    return output;
}
