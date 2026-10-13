const std = @import("std");
pub const Opening = struct { marker: usize, end: usize, self_closing: bool };
pub const Closing = struct { start: usize, end: usize };

pub fn opening(source: []const u8, start: usize) Opening {
    const end = tagEnd(source, start);
    const self_closing = source[end - 2] == '/';

    return .{ .marker = end - if (self_closing) @as(usize, 2) else 1, .end = end, .self_closing = self_closing };
}

pub fn closing(source: []const u8, start: usize) Closing {
    const tag_start = closingStart(source, start);

    return .{ .start = tag_start, .end = tagEnd(source, tag_start) };
}

pub fn tagEnd(source: []const u8, start: usize) usize {
    var offset = start;
    var quote: ?u8 = null;

    while (offset < source.len) : (offset += 1) {
        const byte = source[offset];

        if (quote) |delimiter| {
            if (byte == delimiter) quote = null;
        } else if (byte == '\'' or byte == '"') {
            quote = byte;
        } else if (byte == '>') return offset + 1;
    }

    unreachable;
}

pub fn closingStart(source: []const u8, start: usize) usize {
    var offset = start;

    while (true) {
        offset = std.mem.indexOfScalarPos(u8, source, offset, '<').?;

        if (std.mem.startsWith(u8, source[offset..], "<!--")) {
            offset = commentEnd(source, offset);
        } else if (std.mem.startsWith(u8, source[offset..], "<![CDATA[")) {
            offset = std.mem.indexOfPos(u8, source, offset + 9, "]]>").? + 3;
        } else return offset;
    }
}

pub fn commentEnd(source: []const u8, start: usize) usize {
    return std.mem.indexOfPos(u8, source, start + 4, "-->").? + 3;
}
