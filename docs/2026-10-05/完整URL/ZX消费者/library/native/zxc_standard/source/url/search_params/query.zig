const std = @import("std");
const abi = @import("zxc_abi").native.@"std:url/search_params";

pub fn get(input: abi.Lookup) ?[]const u8 {
    for (input.entries) |entry| if (std.mem.eql(u8, entry.key, input.key)) return entry.value;

    return null;
}

pub fn getAll(allocator: std.mem.Allocator, input: abi.Lookup) ![]const []const u8 {
    var output: std.ArrayList([]const u8) = .empty;

    errdefer output.deinit(allocator);

    for (input.entries) |entry| if (std.mem.eql(u8, entry.key, input.key)) try output.append(allocator, entry.value);

    return output.toOwnedSlice(allocator);
}

pub fn has(input: abi.Match) bool {
    for (input.entries) |entry| if (matches(entry, input.key, input.value)) return true;

    return false;
}

pub fn matches(entry: abi.Entry, key: []const u8, value: ?[]const u8) bool {
    return std.mem.eql(u8, entry.key, key) and (if (value) |expected| std.mem.eql(u8, entry.value, expected) else true);
}
