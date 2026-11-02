const std = @import("std");
const Allocator = std.mem.Allocator;

pub fn encode(allocator: Allocator, input: []const u8) ![]const u8 {
    if (!std.unicode.utf8ValidateSlice(input)) return error.InvalidUtf8;

    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    const hex = "0123456789ABCDEF";

    for (input) |byte| {
        if (std.ascii.isAlphanumeric(byte) or std.mem.indexOfScalar(u8, "-_.!~*'()", byte) != null) {
            try output.append(allocator, byte);
        } else try output.appendSlice(allocator, &.{ '%', hex[byte >> 4], hex[byte & 15] });
    }

    return output.toOwnedSlice(allocator);
}

pub fn decode(allocator: Allocator, input: []const u8, plus_space: bool) ![]const u8 {
    var bytes: std.ArrayList(u8) = .empty;

    defer bytes.deinit(allocator);

    var index: usize = 0;

    while (index < input.len) : (index += 1) {
        const byte = input[index];

        if (byte == '%' and input.len - index >= 3) {
            const high = std.fmt.charToDigit(input[index + 1], 16) catch null;
            const low = std.fmt.charToDigit(input[index + 2], 16) catch null;

            if (high != null and low != null) {
                try bytes.append(allocator, high.? * 16 + low.?);

                index += 2;

                continue;
            }
        }

        try bytes.append(allocator, if (plus_space and byte == '+') ' ' else byte);
    }

    if (std.unicode.utf8ValidateSlice(bytes.items)) return bytes.toOwnedSlice(allocator);

    return @import("utf8.zig").replaceInvalid(allocator, bytes.items);
}
