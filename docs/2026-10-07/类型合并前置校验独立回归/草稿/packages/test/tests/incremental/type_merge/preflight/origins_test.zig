const std = @import("std");
const f = @import("fixture.zig");

fn fullPrefix(omitted: bool) !void {
    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer temporary.deinit();

    const memory = owner.allocator();
    var table = try f.Table.init(memory);
    _ = try f.fill(&table, .base);

    var previous: f.Origins.Storage = .{};

    try previous.appendTable(memory, table.origins.items.view());

    var bindings = if (omitted) f.Bindings{} else table.origins.items.view();

    if (!omitted) {
        const owners = try memory.alloc([]const u8, bindings.count());

        for (bindings.kinds, owners) |kind, *name| name.* = if (kind == 1) "zig:other" else "/fixture/other.zx";

        bindings.owners = owners;
    }

    const mapping = try table.appendFrom(temporary.allocator(), table.items.view(), bindings, table.items.count());

    try f.identity(mapping);
    try f.columnsEqual(previous.view(), table.origins.items.view());
}

test "full prefix does not require omitted nominal coverage" {
    try fullPrefix(true);
}

test "full prefix compares type contents rather than origin identity" {
    try fullPrefix(false);
}

fn duplicate(conflict: bool) !void {
    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer temporary.deinit();

    const memory = owner.allocator();
    var source = try f.Table.init(memory);
    const first = try f.add(&source, .{ .enumeration = .{ .name = "Mode", .members = &.{ "First", "Second" } } });
    const second = try f.add(&source, .{ .enumeration = .{ .name = "Mode", .members = if (conflict) &.{ "First", "Third" } else &.{ "First", "Second" } } });
    var target = try f.Table.init(memory);

    try f.valid(memory, source.items.view());
    try std.testing.expect(first != second);

    if (conflict) {
        try std.testing.expectError(error.ConflictingNominalType, target.appendFrom(temporary.allocator(), source.items.view(), source.origins.items.view(), 0));

        return;
    }

    const mapping = try target.appendFrom(temporary.allocator(), source.items.view(), source.origins.items.view(), 0);
    const origins = target.origins.items.view();

    try std.testing.expectEqual(mapping[@backingInt(first)], mapping[@backingInt(second)]);
    try std.testing.expectEqual(@as(usize, 1), origins.count());
    try std.testing.expectEqualStrings("/fixture/types.zx", origins.at(0).origin.source);
    try std.testing.expectEqualStrings("Mode", origins.at(0).name);
    try std.testing.expectEqualStrings("First", target.items.get(mapping[@backingInt(first)]).enumeration.members[0]);
    try std.testing.expectEqualStrings("Second", target.items.get(mapping[@backingInt(first)]).enumeration.members[1]);
}

test "same input permits distinct ids with one nominal origin and name" {
    try duplicate(false);
}

test "same input sends conflicting nominal contents to intern" {
    try duplicate(true);
}

test "intern reuses later payload ranges with independently remapped children" {
    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer temporary.deinit();

    const memory = owner.allocator();
    var source = try f.Table.init(memory);
    const ids = try f.fill(&source, .base);
    const number: f.ir.TypeId = @fromBackingInt(@backingInt(f.ir.Scalar.u64));
    const boolean: f.ir.TypeId = @fromBackingInt(@backingInt(f.ir.Scalar.bool));
    const pair = try f.add(&source, .{ .tuple = &.{ number, boolean } });
    const record = try f.add(&source, .{ .object = .{ .names = &.{ "pair", "saved" }, .types = &.{ @backingInt(pair), @backingInt(ids.saved) }, .len = 2 } });
    const errors = try f.add(&source, .{ .error_set = &.{ "First", "Second" } });
    const list = try f.add(&source, .{ .list = record });
    const task = try f.add(&source, .{ .task = .{ .result = record, .errors = errors } });
    const different_pair = try f.add(&source, .{ .tuple = &.{ number, number } });
    const different_record = try f.add(&source, .{ .object = .{ .names = &.{ "pair", "stored" }, .types = &.{ @backingInt(pair), @backingInt(ids.saved) }, .len = 2 } });
    var target = try f.Table.init(memory);

    try f.valid(memory, source.items.view());

    const mapping = try target.appendFrom(temporary.allocator(), source.items.view(), source.origins.items.view(), 0);

    try std.testing.expectEqual(mapping[@backingInt(ids.pair)], mapping[@backingInt(pair)]);
    try std.testing.expectEqual(mapping[@backingInt(ids.record)], mapping[@backingInt(record)]);
    try std.testing.expectEqual(mapping[@backingInt(ids.errors)], mapping[@backingInt(errors)]);
    try std.testing.expect(mapping[@backingInt(errors)] != mapping[@backingInt(ids.mode)]);
    try std.testing.expectEqual(mapping[@backingInt(ids.list)], mapping[@backingInt(list)]);
    try std.testing.expectEqual(mapping[@backingInt(ids.task)], mapping[@backingInt(task)]);
    try std.testing.expect(mapping[@backingInt(ids.pair)] != mapping[@backingInt(different_pair)]);
    try std.testing.expect(mapping[@backingInt(ids.record)] != mapping[@backingInt(different_record)]);
}

fn bindingRejected(kind: enum { node, task, errors }) !void {
    var owner = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owner.deinit();

    var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer temporary.deinit();

    var table = try f.Table.init(owner.allocator());
    const ids = try f.fill(&table, .base);

    const index = switch (kind) {
        .node => ids.node,
        .task => ids.task,
        .errors => ids.errors,
    };

    const name: []const u8 = switch (kind) {
        .node => "Node",
        .task => "Task",
        .errors => "Errors",
    };

    const indices = [_]u32{@backingInt(index)};
    const bindings: f.Bindings = .{ .ids = &indices, .kinds = &.{0}, .owners = &.{"/fixture/types.zx"}, .members = &.{""}, .names = &.{name} };

    try std.testing.expectError(error.InvalidModule, table.appendFrom(temporary.allocator(), table.items.view(), bindings, table.items.count()));
}

test "native reference binding requires native origin before prefix reuse" {
    try bindingRejected(.node);
}

test "task cannot be a nominal binding target before prefix reuse" {
    try bindingRejected(.task);
}

test "error set cannot be a nominal binding target before prefix reuse" {
    try bindingRejected(.errors);
}
