const std = @import("std");
const Columns = @import("../layout.zig").Columns;

pub fn plan(allocator: std.mem.Allocator, fragments: []const []const u8, expressions: []const []const u8) std.mem.Allocator.Error!Columns {
    var tails: std.StringHashMapUnmanaged(u32) = .empty;
    var starts: std.ArrayList(u32) = .empty;
    const next = try allocator.alloc(?u32, fragments.len);

    @memset(next, null);

    for (fragments, 0..) |name, index| {
        const entry = try tails.getOrPut(allocator, name);

        if (entry.found_existing) {
            next[entry.value_ptr.*] = @intCast(index);
        } else {
            try starts.append(allocator, @intCast(index));
        }

        entry.value_ptr.* = @intCast(index);
    }

    const names = try allocator.alloc([]const u8, expressions.len);
    const ends = try allocator.alloc(u64, expressions.len);
    var text: std.ArrayList(u8) = .empty;

    for (expressions, names, ends, 0..) |expression, *name, *end, index| {
        name.* = try std.fmt.allocPrint(allocator, "StoreValue{d}", .{index});

        try text.appendSlice(allocator, "export type ");
        try text.appendSlice(allocator, name.*);
        try text.appendSlice(allocator, " = ");
        try text.appendSlice(allocator, expression);
        try text.append(allocator, '\n');

        end.* = text.items.len;
    }

    return .{ .starts = starts.items, .next = next, .names = names, .ends = ends, .text = text.items };
}
