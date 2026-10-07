const std = @import("std");
const abi = @import("zxc_abi").native.@"std:url/search_params";
const layouts = @import("zxc_abi").layouts.@"std:url/search_params";
const percent = @import("../../querystring/percent.zig");

pub fn parse(allocator: std.mem.Allocator, input: []const u8) ![]const abi.Entry {
    const source = if (std.mem.startsWith(u8, input, "?")) input[1..] else input;
    var output: std.ArrayList(abi.Entry) = .empty;

    errdefer {
        for (output.items) |entry| {
            allocator.free(entry.key);
            allocator.free(entry.value);
            allocator.destroy(entry);
        }

        output.deinit(allocator);
    }

    var parts = std.mem.splitScalar(u8, source, '&');

    while (parts.next()) |part| {
        if (part.len == 0) continue;

        const boundary = std.mem.indexOfScalar(u8, part, '=');
        const key = try percent.decode(allocator, part[0 .. boundary orelse part.len], true);

        errdefer allocator.free(key);

        const value = try percent.decode(allocator, if (boundary) |index| part[index + 1 ..] else "", true);

        errdefer allocator.free(value);

        const entry = try allocator.create(layouts.Entry);

        errdefer allocator.destroy(entry);

        entry.* = .{ .key = key, .value = value };

        try output.append(allocator, entry);
    }

    return output.toOwnedSlice(allocator);
}
