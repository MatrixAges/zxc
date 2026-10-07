const std = @import("std");
const abi = @import("zxc_abi").native.@"std:url/search_params";

pub fn stringify(allocator: std.mem.Allocator, input: []const abi.Entry) ![]const u8 {
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    for (input, 0..) |entry, index| {
        if (index != 0) try output.append(allocator, '&');
        try encode(allocator, &output, entry.key);
        try output.append(allocator, '=');
        try encode(allocator, &output, entry.value);
    }

    return output.toOwnedSlice(allocator);
}

fn encode(allocator: std.mem.Allocator, output: *std.ArrayList(u8), input: []const u8) !void {
    if (!std.unicode.utf8ValidateSlice(input)) return error.InvalidUtf8;

    const hex = "0123456789ABCDEF";

    for (input) |byte| {
        if (std.ascii.isAlphanumeric(byte) or std.mem.indexOfScalar(u8, "*-._", byte) != null) {
            try output.append(allocator, byte);
        } else if (byte == ' ') {
            try output.append(allocator, '+');
        } else try output.appendSlice(allocator, &.{ '%', hex[byte >> 4], hex[byte & 15] });
    }
}
