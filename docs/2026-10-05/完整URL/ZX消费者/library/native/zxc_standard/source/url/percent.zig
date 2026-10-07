const std = @import("std");
pub const Set = enum { control, fragment, query, special_query, path, userinfo, component };

pub fn encode(allocator: std.mem.Allocator, input: []const u8, set: Set) ![]const u8 {
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    const hex = "0123456789ABCDEF";

    for (input) |byte| {
        if (contains(set, byte)) {
            try output.appendSlice(allocator, &.{ '%', hex[byte >> 4], hex[byte & 15] });
        } else try output.append(allocator, byte);
    }

    return output.toOwnedSlice(allocator);
}

pub fn decode(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    var index: usize = 0;

    while (index < input.len) : (index += 1) {
        if (input[index] == '%' and input.len - index >= 3) {
            const high = std.fmt.charToDigit(input[index + 1], 16) catch null;
            const low = std.fmt.charToDigit(input[index + 2], 16) catch null;

            if (high != null and low != null) {
                try output.append(allocator, high.? * 16 + low.?);

                index += 2;

                continue;
            }
        }

        try output.append(allocator, input[index]);
    }

    return output.toOwnedSlice(allocator);
}

fn contains(set: Set, byte: u8) bool {
    if (byte < 0x20 or byte > 0x7e) return true;

    return switch (set) {
        .control => false,
        .fragment => member(byte, " \"<>`"),
        .query => member(byte, " \"#<>"),
        .special_query => contains(.query, byte) or byte == '\'',
        .path => contains(.query, byte) or member(byte, "?^`{}"),
        .userinfo => contains(.path, byte) or member(byte, "/:;=@[\\]|"),
        .component => contains(.userinfo, byte) or member(byte, "$%&+,"),
    };
}

fn member(byte: u8, values: []const u8) bool {
    return std.mem.indexOfScalar(u8, values, byte) != null;
}
