const std = @import("std");
pub const f = @import("../fixture.zig");
pub const names = [_][]const u8{ "item", "item1", "item10", "item2", "itemA", "itemZ" };
pub const errors = [_][]const u8{ "Error", "Error1", "Error10", "Error2", "ErrorA", "ErrorZ" };
pub const scalars = [_]f.ir.Scalar{ .bool, .u8, .u32, .u64, .f64, .string };

pub fn order(rank: usize) [6]usize {
    var available = [_]usize{ 0, 1, 2, 3, 4, 5 };
    var result: [6]usize = undefined;
    var rest = rank;
    const divisors = [_]usize{ 120, 24, 6, 2, 1, 1 };

    for (divisors, 0..) |divisor, index| {
        const selected = rest / divisor;
        const len = available.len - index;
        rest %= divisor;
        result[index] = available[selected];

        std.mem.copyForwards(usize, available[selected .. len - 1], available[selected + 1 .. len]);
    }

    return result;
}

pub fn graph(types: f.Types, id: f.ir.TypeId, labels: []const []const u8) !void {
    const fields = types.get(id).object;

    try std.testing.expectEqual(labels.len, fields.len);

    for (labels, 0..) |label, index| {
        try std.testing.expectEqualStrings(label, fields.at(index).name);
        try std.testing.expectEqual(f.scalar(scalars[index % scalars.len]), fields.at(index).type_id);
    }

    try f.prefix(types);
}

pub fn width(count: usize) !void {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    const allocator = memory.allocator();
    var reporter: f.zx.Reporter = .{};
    var types = try f.base(allocator, &reporter, &.{});
    const labels = try allocator.alloc([]const u8, count);

    for (labels, 0..) |*label, index| label.* = try std.fmt.allocPrint(allocator, "field{d:0>3}", .{index});

    var identity: ?f.ir.TypeId = null;

    for (0..3) |layout| {
        const fields = try f.Types.Fields.init(allocator, count);

        for (0..count) |index| {
            const source = switch (layout) {
                0 => index,
                1 => count - 1 - index,
                else => (index + count / 2) % count,
            };

            fields.set(index, labels[source], f.scalar(scalars[source % scalars.len]));
        }

        const before_names = try allocator.dupe([]const u8, fields.names);
        const before_types = try allocator.dupe(u32, fields.types);
        const id = try types.object(fields);

        if (identity) |previous| try std.testing.expectEqual(previous, id);

        identity = id;

        try graph(types, id, labels);
        try std.testing.expectEqualSlices(u32, before_types, fields.types);
        for (before_names, fields.names) |before, after| try std.testing.expectEqualStrings(before, after);
    }

    try std.testing.expectEqual(std.enums.values(f.ir.Scalar).len + 1, types.items.count());
    try std.testing.expectEqual(null, reporter.diagnostic);
}
