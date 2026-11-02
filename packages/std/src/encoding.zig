const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn encodeBase64(allocator: Allocator, bytes: []const u8) Allocator.Error![]const u8 {
    const encoder = std.base64.standard.Encoder;
    const output = try allocator.alloc(u8, encoder.calcSize(bytes.len));

    return encoder.encode(output, bytes);
}

pub fn decodeBase64(allocator: Allocator, text: []const u8) ![]const u8 {
    const decoder = std.base64.standard.Decoder;
    const output = try allocator.alloc(u8, try decoder.calcSizeForSlice(text));

    errdefer allocator.free(output);

    try decoder.decode(output, text);

    return output;
}

pub fn encodeHex(allocator: Allocator, bytes: []const u8) ![]const u8 {
    const output = try allocator.alloc(u8, try std.math.mul(usize, bytes.len, 2));
    const alphabet = "0123456789abcdef";

    for (bytes, 0..) |byte, index| {
        output[index * 2] = alphabet[byte >> 4];
        output[index * 2 + 1] = alphabet[byte & 15];
    }

    return output;
}

pub fn decodeHex(allocator: Allocator, text: []const u8) ![]const u8 {
    if (text.len % 2 != 0) return error.InvalidHex;

    const output = try allocator.alloc(u8, text.len / 2);

    errdefer allocator.free(output);

    return std.fmt.hexToBytes(output, text);
}

pub fn encodeUtf8(text: []const u8) ![]const u8 {
    if (!std.unicode.utf8ValidateSlice(text)) return error.InvalidUtf8;

    return text;
}

pub fn decodeUtf8(bytes: []const u8) ![]const u8 {
    if (!std.unicode.utf8ValidateSlice(bytes)) return error.InvalidUtf8;

    return bytes;
}

pub fn sliceBytes(text: []const u8, start: u64, end: u64) error{InvalidRange}![]const u8 {
    if (start > end or end > text.len) return error.InvalidRange;

    return text[@intCast(start)..@intCast(end)];
}
