const std = @import("std");

pub fn decode(allocator: std.mem.Allocator, text: []const u8) std.mem.Allocator.Error![]const u8 {
    var output: std.ArrayList(u8) = .empty;
    var index: usize = 0;

    while (index < text.len) : (index += 1) {
        var byte = text[index];

        if (byte == '\\' and index + 1 < text.len) {
            index += 1;

            byte = switch (text[index]) {
                'n' => '\n',
                'r' => '\r',
                't' => '\t',
                else => text[index],
            };
        }

        try output.append(allocator, byte);
    }

    return output.toOwnedSlice(allocator);
}
