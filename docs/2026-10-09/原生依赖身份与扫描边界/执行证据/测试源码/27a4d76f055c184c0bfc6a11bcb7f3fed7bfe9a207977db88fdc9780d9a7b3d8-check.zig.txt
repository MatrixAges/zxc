const std = @import("std");
pub const f = @import("input.zig");

pub fn copy(memory: std.mem.Allocator, value: anytype) !@TypeOf(value) {
    var copied: @TypeOf(value) = .{};

    inline for (@typeInfo(@TypeOf(value)).@"struct".field_names) |name| {
        const column = @field(value, name);
        const owned = try memory.dupe(@typeInfo(@TypeOf(column)).pointer.child, column);

        if (@typeInfo(@TypeOf(column)).pointer.child == []const u8) {
            for (column, owned) |text, *item| item.* = try memory.dupe(u8, text);
        }

        @field(copied, name) = owned;
    }

    return copied;
}

pub fn same(left: anytype, right: @TypeOf(left)) !void {
    inline for (@typeInfo(@TypeOf(left)).@"struct".field_names) |name| {
        const a = @field(left, name);
        const b = @field(right, name);

        try std.testing.expectEqual(a.len, b.len);

        if (@typeInfo(@TypeOf(a)).pointer.child == []const u8) {
            for (a, b) |x, y| try std.testing.expectEqualStrings(x, y);
        } else try std.testing.expectEqualSlices(@typeInfo(@TypeOf(a)).pointer.child, a, b);
    }
}

pub fn prefix(items: *f.Origins, input: f.Input) !void {
    const first = input.nominal[0];

    try items.items.append(items.allocator, .{ .type_id = first.id, .origin = .{ .source = "/previous.zx" }, .name = first.name });
}

pub fn result(items: f.Origins, input: f.Input, first: usize, origin: f.Origins.Origin, held: bool) !void {
    const table = items.items.view();
    var count: usize = @intFromBool(held);

    try std.testing.expect(table.hasValidShape());

    if (held) {
        const old = table.at(0);

        try std.testing.expectEqual(input.nominal[0].id, old.type_id);
        try std.testing.expectEqualStrings(input.nominal[0].name, old.name);
        try std.testing.expect(f.Origins.same(.{ .source = "/previous.zx" }, old.origin));
    }

    for (input.nominal) |expected| {
        if (@backingInt(expected.id) < first) continue;

        const item = table.at(count);

        try std.testing.expectEqual(expected.id, item.type_id);
        try std.testing.expectEqualStrings(expected.name, item.name);
        try std.testing.expect(f.Origins.same(origin, item.origin));

        count += 1;
    }

    try std.testing.expectEqual(count, table.count());
}

pub fn boundaries(origin: f.Origins.Origin, held: bool) !void {
    var setup = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer setup.deinit();

    const input = try f.create(setup.allocator(), origin == .native);
    const snapshot = try copy(setup.allocator(), input.types);
    const start = if (held) @as(usize, @backingInt(input.nominal[0].id)) + 1 else 0;

    for (start..input.types.count() + 1) |first| {
        var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer owner.deinit();

        var items = f.Origins{ .allocator = owner.allocator() };

        if (held) try prefix(&items, input);

        try items.append(input.types, first, origin);
        try result(items, input, first, origin, held);
        try same(snapshot, input.types);
    }
}
