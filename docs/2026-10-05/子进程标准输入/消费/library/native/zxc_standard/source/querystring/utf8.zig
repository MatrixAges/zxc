const std = @import("std");

pub fn replaceInvalid(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    var index: usize = 0;

    while (index < input.len) {
        const first = input[index];
        const width: usize = if (first < 0x80) 1 else if (first >= 0xc2 and first <= 0xdf) 2 else if (first >= 0xe0 and first <= 0xef) 3 else if (first >= 0xf0 and first <= 0xf4) 4 else 0;
        var count: usize = 1;

        while (count < width and count < input.len - index) : (count += 1) {
            const byte = input[index + count];

            if (byte < 0x80 or byte > 0xbf) break;
            if (count == 1 and ((first == 0xe0 and byte < 0xa0) or (first == 0xed and byte > 0x9f) or (first == 0xf0 and byte < 0x90) or (first == 0xf4 and byte > 0x8f))) break;
        }

        if (width != 0 and count == width) {
            try output.appendSlice(allocator, input[index .. index + count]);
        } else try output.appendSlice(allocator, &std.unicode.replacement_character_utf8);

        index += count;
    }

    return output.toOwnedSlice(allocator);
}
