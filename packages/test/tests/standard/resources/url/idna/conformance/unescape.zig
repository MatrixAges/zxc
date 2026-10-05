const std = @import("std");

pub fn decode(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    if (std.mem.eql(u8, input, "\"\"")) return allocator.alloc(u8, 0);

    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    var index: usize = 0;

    while (index < input.len) {
        if (input[index] != '\\') {
            try output.append(allocator, input[index]);

            index += 1;

            continue;
        }

        const start: usize, const end: usize, const next: usize = if (std.mem.startsWith(u8, input[index..], "\\u") and input.len - index >= 6)
            .{ index + 2, index + 6, index + 6 }

        else if (std.mem.startsWith(u8, input[index..], "\\x{")) blk: {
            const end = std.mem.indexOfScalarPos(u8, input, index + 3, '}') orelse return error.InvalidEscape;

            break :blk .{ index + 3, end, end + 1 };
        } else return error.InvalidEscape;

        const point = try std.fmt.parseInt(u21, input[start..end], 16);

        if (point >= 0xd800 and point <= 0xdfff) {
            try output.appendSlice(allocator, &.{ 0xe0 | @as(u8, @intCast(point >> 12)), 0x80 | @as(u8, @intCast((point >> 6) & 0x3f)), 0x80 | @as(u8, @intCast(point & 0x3f)) });
        } else {
            var buffer: [4]u8 = undefined;
            const length = try std.unicode.utf8Encode(point, &buffer);

            try output.appendSlice(allocator, buffer[0..length]);
        }

        index = next;
    }

    return output.toOwnedSlice(allocator);
}
