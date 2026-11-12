const std = @import("std");
const rx = @import("rx");
const Columns = @import("../layout.zig").Columns;
const target = @import("../../call/target.zig");

pub fn group(allocator: std.mem.Allocator, children: []const rx.ast.Node) std.mem.Allocator.Error!rx.store.Groups {
    var first: usize = 0;

    while (first < children.len and std.mem.eql(u8, children[first].name, "Type")) : (first += 1) {}

    const fragments = children[first..];

    if (fragments.len > std.math.maxInt(u32)) return error.OutOfMemory;

    var tails: std.StringHashMapUnmanaged(u32) = .empty;
    var starts: std.ArrayList(u32) = .empty;
    const next = try allocator.alloc(?u32, fragments.len);

    @memset(next, null);

    for (fragments, 0..) |fragment, index| {
        const name = target.attribute(fragment, "name").value;
        const entry = try tails.getOrPut(allocator, name);

        if (entry.found_existing) {
            next[entry.value_ptr.*] = @intCast(index);
        } else {
            try starts.append(allocator, @intCast(index));
        }

        entry.value_ptr.* = @intCast(index);
    }

    return .{ .first = first, .starts = starts.items, .next = next };
}

pub fn plan(allocator: std.mem.Allocator, expressions: []const []const u8) std.mem.Allocator.Error!Columns {
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

    return .{ .names = names, .ends = ends, .text = text.items };
}
