const std = @import("std");
const h = @import("ordering/fixture.zig");
const f = h.f;

test "all six field name permutations preserve paired types and canonical identity" {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    const allocator = memory.allocator();
    var reporter: f.zx.Reporter = .{};
    var types = try f.base(allocator, &reporter, &.{});
    var identity: ?f.ir.TypeId = null;

    for (0..720) |rank| {
        const fields = try f.Types.Fields.init(allocator, h.names.len);

        for (h.order(rank), 0..) |source, index| fields.set(index, h.names[source], f.scalar(h.scalars[source]));

        const before_names = try allocator.dupe([]const u8, fields.names);
        const before_types = try allocator.dupe(u32, fields.types);
        const id = try types.object(fields);

        if (identity) |previous| try std.testing.expectEqual(previous, id);

        identity = id;

        try h.graph(types, id, &h.names);
        try std.testing.expectEqualSlices(u32, before_types, fields.types);
        for (before_names, fields.names) |before, after| try std.testing.expectEqualStrings(before, after);
    }

    try std.testing.expectEqual(std.enums.values(f.ir.Scalar).len + 1, types.items.count());
    try std.testing.expectEqual(null, reporter.diagnostic);
}

test "all six error member permutations preserve lexical order identity and inputs" {
    var memory = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer memory.deinit();

    var reporter: f.zx.Reporter = .{};
    var types = try f.base(memory.allocator(), &reporter, &.{});
    var identity: ?f.ir.TypeId = null;

    for (0..720) |rank| {
        var members: [6][]const u8 = undefined;

        for (h.order(rank), 0..) |source, index| members[index] = h.errors[source];

        const before = members;
        const id = try types.errorSet(&members);

        if (identity) |previous| try std.testing.expectEqual(previous, id);

        identity = id;

        for (h.errors, types.get(id).error_set) |expected, actual| try std.testing.expectEqualStrings(expected, actual);
        for (before, members) |expected, actual| try std.testing.expectEqualStrings(expected, actual);
        try f.prefix(types);
    }

    try std.testing.expectEqual(std.enums.values(f.ir.Scalar).len + 1, types.items.count());
    try std.testing.expectEqual(null, reporter.diagnostic);
}

test "empty object has one canonical type across field layouts" {
    try h.width(0);
}

test "single field object preserves its paired type across field layouts" {
    try h.width(1);
}

test "twenty three field object canonicalizes across field layouts" {
    try h.width(23);
}

test "twenty four field object canonicalizes across field layouts" {
    try h.width(24);
}

test "twenty five field object canonicalizes across field layouts" {
    try h.width(25);
}

test "thirty two field object canonicalizes across field layouts" {
    try h.width(32);
}

test "sixty five field object canonicalizes across field layouts" {
    try h.width(65);
}

test "one hundred twenty nine field object canonicalizes across field layouts" {
    try h.width(129);
}
