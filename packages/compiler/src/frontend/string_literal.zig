const std = @import("std");

pub fn decode(allocator: std.mem.Allocator, text: []const u8) std.mem.Allocator.Error![]const u8 {
    var output: std.ArrayList(u8) = .empty;
    var index: usize = 0;

    while (next(text, &index)) |byte| try output.append(allocator, byte);

    return output.toOwnedSlice(allocator);
}

pub fn equal(text: []const u8, value: []const u8) bool {
    var source_index: usize = 0;
    var value_index: usize = 0;

    while (next(text, &source_index)) |byte| {
        if (value_index == value.len or value[value_index] != byte) return false;

        value_index += 1;
    }

    return value_index == value.len;
}

fn next(text: []const u8, index: *usize) ?u8 {
    if (index.* == text.len) return null;

    const byte = text[index.*];

    index.* += 1;

    if (byte != '\\' or index.* == text.len) return byte;

    const escaped = text[index.*];

    index.* += 1;

    return switch (escaped) {
        'n' => '\n',
        'r' => '\r',
        't' => '\t',
        else => escaped,
    };
}
