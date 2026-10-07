const std = @import("std");
const abi = @import("zxc_abi").native.@"std:url/search_params";
const layouts = @import("zxc_abi").layouts.@"std:url/search_params";
const matches = @import("query.zig").matches;

pub fn append(allocator: std.mem.Allocator, input: abi.Update) ![]const abi.Entry {
    const length = try std.math.add(usize, input.entries.len, 1);
    const output = try allocator.alloc(abi.Entry, length);

    errdefer allocator.free(output);

    const entry = try allocator.create(layouts.Entry);

    entry.* = .{ .key = input.key, .value = input.value };

    @memcpy(output[0..input.entries.len], input.entries);

    output[input.entries.len] = entry;

    return output;
}

pub fn set(allocator: std.mem.Allocator, input: abi.Update) ![]const abi.Entry {
    const entry = try allocator.create(layouts.Entry);

    errdefer allocator.destroy(entry);

    entry.* = .{ .key = input.key, .value = input.value };

    var output: std.ArrayList(abi.Entry) = .empty;

    errdefer output.deinit(allocator);

    var replaced = false;

    for (input.entries) |current| {
        if (!std.mem.eql(u8, current.key, input.key)) {
            try output.append(allocator, current);
        } else if (!replaced) {
            try output.append(allocator, entry);

            replaced = true;
        }
    }

    if (!replaced) try output.append(allocator, entry);

    return output.toOwnedSlice(allocator);
}

pub fn remove(allocator: std.mem.Allocator, input: abi.Match) ![]const abi.Entry {
    var output: std.ArrayList(abi.Entry) = .empty;

    errdefer output.deinit(allocator);

    for (input.entries) |entry| if (!matches(entry, input.key, input.value)) try output.append(allocator, entry);

    return output.toOwnedSlice(allocator);
}
