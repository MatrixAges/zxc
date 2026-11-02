const std = @import("std");
const abi = @import("zxc_abi").native.@"std:querystring";
const layouts = @import("zxc_abi").layouts.@"std:querystring";
const percent = @import("percent.zig");

pub fn parse(allocator: std.mem.Allocator, input: abi.ParseOptions) ![]const abi.Entry {
    const separator = if (input.separator.len == 0) "&" else input.separator;
    const assignment = if (input.assignment.len == 0) "=" else input.assignment;
    var output: std.ArrayList(abi.Entry) = .empty;

    errdefer {
        for (output.items) |entry| {
            allocator.free(entry.key);
            allocator.free(entry.value);
            allocator.destroy(entry);
        }

        output.deinit(allocator);
    }

    var parts = std.mem.splitSequence(u8, input.query, separator);
    var count: usize = 0;

    while (parts.next()) |part| {
        if (input.max_keys != 0 and count >= input.max_keys) break;

        count += 1;

        if (part.len == 0) continue;

        const boundary = std.mem.indexOf(u8, part, assignment);
        const key = try percent.decode(allocator, part[0 .. boundary orelse part.len], true);

        errdefer allocator.free(key);

        const value = try percent.decode(allocator, if (boundary) |index| part[index + assignment.len ..] else "", true);

        errdefer allocator.free(value);

        const entry = try allocator.create(layouts.Entry);

        errdefer allocator.destroy(entry);

        entry.* = .{ .key = key, .value = value };

        try output.append(allocator, entry);
    }

    return output.toOwnedSlice(allocator);
}
