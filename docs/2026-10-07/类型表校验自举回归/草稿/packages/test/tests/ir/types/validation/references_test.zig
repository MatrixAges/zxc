const std = @import("std");
const F = @import("fixture.zig");
const ir = F.ir;

test "empty table is missing the scalar prefix" {
    var f = try F.init();

    defer f.deinit();

    try f.checkTable(.{}, false, true);
}

test "last missing scalar is rejected despite valid shape" {
    var f = try F.init();

    defer f.deinit();

    try f.checkTable(f.storage.view().prefix(std.enums.values(ir.Scalar).len - 1), false, true);
}

test "scalar identity must match its prefix position" {
    var f = try F.init();

    defer f.deinit();
    std.mem.swap(u32, &f.storage.first.items[0], &f.storage.first.items[1]);

    try f.check(false, true);
}

test "optional kind cannot replace a scalar prefix slot" {
    var f = try F.init();

    defer f.deinit();

    f.storage.kinds.items[1] = @backingInt(std.meta.Tag(ir.TypeValue).optional);
    f.storage.first.items[1] = 0;

    try f.check(false, true);
}

test "extra scalar after the complete prefix is rejected" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .scalar = .u64 });

    try f.check(false, true);
}

test "optional self child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.optional] = @intCast(f.ids.optional);

    try f.check(false, true);
}

test "optional forward child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.optional] = @intCast(f.ids.optional + 1);

    try f.check(false, true);
}

test "optional maximum child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.optional] = std.math.maxInt(u32);

    try f.check(false, true);
}

test "optional cannot directly contain a previous task" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .optional = F.id(f.ids.task) });

    try f.check(false, true);
}

test "list self child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.list] = @intCast(f.ids.list);

    try f.check(false, true);
}

test "list forward child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.list] = @intCast(f.ids.list + 1);

    try f.check(false, true);
}

test "list maximum child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.list] = std.math.maxInt(u32);

    try f.check(false, true);
}

test "list cannot directly contain a previous task" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .list = F.id(f.ids.task) });

    try f.check(false, true);
}

test "list cannot directly contain void" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.list] = 0;

    try f.check(false, true);
}

test "tuple later self child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.children.items[f.storage.first.items[f.ids.tuple] + 1] = @intCast(f.ids.tuple);

    try f.check(false, true);
}

test "tuple later forward child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.children.items[f.storage.first.items[f.ids.tuple] + 1] = @intCast(f.ids.tuple + 1);

    try f.check(false, true);
}

test "tuple later maximum child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.children.items[f.storage.first.items[f.ids.tuple] + 1] = std.math.maxInt(u32);

    try f.check(false, true);
}

test "tuple cannot directly contain a previous task" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .tuple = &.{ F.scalar(.bool), F.id(f.ids.task) } });

    try f.check(false, true);
}

test "object later self child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.field_types.items[f.storage.first.items[f.ids.object] + 1] = @intCast(f.ids.object);

    try f.check(false, true);
}

test "object later forward child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.field_types.items[f.storage.first.items[f.ids.object] + 1] = @intCast(f.ids.object + 1);

    try f.check(false, true);
}

test "object later maximum child is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.field_types.items[f.storage.first.items[f.ids.object] + 1] = std.math.maxInt(u32);

    try f.check(false, true);
}

test "object cannot directly contain a previous task" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .object = .{ .names = &.{ "alpha", "omega" }, .types = &.{ 1, @intCast(f.ids.task) }, .len = 2 } });

    try f.check(false, true);
}

test "object later field cannot have void type" {
    var f = try F.init();

    defer f.deinit();

    f.storage.field_types.items[f.storage.first.items[f.ids.object] + 1] = 0;

    try f.check(false, true);
}

test "task self result is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.task] = @intCast(f.ids.task);

    try f.check(false, true);
}

test "task maximum result is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.task] = std.math.maxInt(u32);

    try f.check(false, true);
}

test "task self errors is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.task] = @intCast(f.ids.task);

    try f.check(false, true);
}

test "task maximum errors is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.task] = std.math.maxInt(u32);

    try f.check(false, true);
}

test "task errors must refer to error set" {
    var f = try F.init();

    defer f.deinit();

    f.storage.second.items[f.ids.task] = @intCast(f.ids.native);

    try f.check(false, true);
}

test "task result cannot be a previous task" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .task = .{ .result = F.id(f.ids.task), .errors = F.id(f.ids.errors) } });

    try f.check(false, true);
}

test "task errors cannot be a previous task" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .task = .{ .result = F.scalar(.u64), .errors = F.id(f.ids.task) } });

    try f.check(false, true);
}
