const std = @import("std");
const abi = @import("zxc_abi").native.@"std:url/search_params";
const Item = struct { entry: abi.Entry, key: []const u16 };

pub fn sort(allocator: std.mem.Allocator, input: []const abi.Entry) ![]const abi.Entry {
    const items = try allocator.alloc(Item, input.len);

    defer allocator.free(items);

    var initialized: usize = 0;

    defer for (items[0..initialized]) |item| allocator.free(item.key);

    for (input, items) |entry, *item| {
        item.* = .{ .entry = entry, .key = try std.unicode.utf8ToUtf16LeAlloc(allocator, entry.key) };
        initialized += 1;
    }

    std.mem.sort(Item, items, {}, lessThan);

    const output = try allocator.alloc(abi.Entry, input.len);

    for (items, output) |item, *entry| entry.* = item.entry;

    return output;
}

fn lessThan(_: void, left: Item, right: Item) bool {
    for (left.key[0..@min(left.key.len, right.key.len)], right.key[0..@min(left.key.len, right.key.len)]) |left_unit, right_unit| {
        const a = std.mem.littleToNative(u16, left_unit);
        const b = std.mem.littleToNative(u16, right_unit);

        if (a != b) return a < b;
    }

    return left.key.len < right.key.len;
}
