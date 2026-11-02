const std = @import("std");
const abi = @import("zxc_abi").native.@"std:querystring";
const percent = @import("percent.zig");

pub fn stringify(allocator: std.mem.Allocator, input: abi.StringifyOptions) ![]const u8 {
    const separator = if (input.separator.len == 0) "&" else input.separator;
    const assignment = if (input.assignment.len == 0) "=" else input.assignment;
    var output: std.ArrayList(u8) = .empty;

    errdefer output.deinit(allocator);

    for (input.entries, 0..) |entry, index| {
        const key = try percent.encode(allocator, entry.key);

        defer allocator.free(key);

        const value = try percent.encode(allocator, entry.value);

        defer allocator.free(value);

        if (index != 0) try output.appendSlice(allocator, separator);
        try output.appendSlice(allocator, key);
        try output.appendSlice(allocator, assignment);
        try output.appendSlice(allocator, value);
    }

    return output.toOwnedSlice(allocator);
}
