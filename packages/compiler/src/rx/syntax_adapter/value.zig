const std = @import("std");

pub fn convert(allocator: std.mem.Allocator, source: []const u8, parts: anytype, value: anytype) ![]const u8 {
    if (value.head == 0) return source[@intCast(value.span.start)..@intCast(value.span.end)];

    const end: usize = @intCast(value.head);
    const count: usize = @intCast(value.count);
    const items = parts[end - count .. end];
    var length: usize = 0;

    for (items) |part| {
        length += if (part.character) std.unicode.utf8CodepointSequenceLength(@intCast(part.codepoint)) catch unreachable else @as(usize, @intCast(part.span.end - part.span.start));
    }

    const output = try allocator.alloc(u8, length);
    var cursor: usize = 0;

    for (items) |part| {
        var buffer: [4]u8 = undefined;
        const bytes = if (part.character) buffer[0 .. std.unicode.utf8Encode(@intCast(part.codepoint), &buffer) catch unreachable] else source[@intCast(part.span.start)..@intCast(part.span.end)];

        @memcpy(output[cursor..][0..bytes.len], bytes);

        cursor += bytes.len;
    }

    return output;
}
