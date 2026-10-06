const std = @import("std");
const F = @import("fixture.zig");
const ir = F.ir;

test "valid table covers all nine kinds without validation allocations" {
    var f = try F.init();

    defer f.deinit();

    try f.check(true, true);
}

test "complete scalar only prefix is accepted" {
    var f = try F.init();

    defer f.deinit();

    try f.checkTable(f.storage.view().prefix(std.enums.values(ir.Scalar).len), true, true);
}

test "optional void is permitted" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.optional] = 0;

    try f.check(true, true);
}

test "tuple void element is permitted" {
    var f = try F.init();

    defer f.deinit();

    f.storage.children.items[f.storage.first.items[f.ids.tuple] + 1] = 0;

    try f.check(true, true);
}

test "task void result is permitted" {
    var f = try F.init();

    defer f.deinit();

    f.storage.first.items[f.ids.task] = 0;

    try f.check(true, true);
}

test "empty tuple is permitted" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .tuple = &.{} });

    try f.check(true, true);
}

test "empty error_set is permitted" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .error_set = &.{} });

    try f.check(true, true);
}

test "empty object is permitted" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .object = .{ .names = &.{}, .types = &.{}, .len = 0 } });

    try f.check(true, true);
}

test "task can use an empty error set" {
    var f = try F.init();

    defer f.deinit();

    const errors = try f.add(.{ .error_set = &.{} });

    _ = try f.add(.{ .task = .{ .result = F.scalar(.void), .errors = F.id(errors) } });

    try f.check(true, true);
}

test "enum label and unique members need not use PascalCase or sorted order" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.enumeration] = "mixed label";
    f.storage.names.items[f.storage.first.items[f.ids.enumeration]] = "zeta value";
    f.storage.names.items[f.storage.first.items[f.ids.enumeration] + 1] = "Alpha";
    f.storage.names.items[f.storage.first.items[f.ids.enumeration] + 2] = "中";

    try f.check(true, true);
}

test "object field names require nonempty byte order rather than identifier syntax" {
    var f = try F.init();

    defer f.deinit();

    f.storage.field_names.items[f.storage.first.items[f.ids.object]] = "0 field";
    f.storage.field_names.items[f.storage.first.items[f.ids.object] + 1] = "z?";

    try f.check(true, true);
}

test "object uppercase field precedes lowercase field by byte order" {
    var f = try F.init();

    defer f.deinit();

    f.storage.field_names.items[f.storage.first.items[f.ids.object]] = "B";
    f.storage.field_names.items[f.storage.first.items[f.ids.object] + 1] = "a";

    try f.check(true, true);
}

test "numeric suffix error ordering is lexical" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.errors]] = "Error10";
    f.storage.names.items[f.storage.first.items[f.ids.errors] + 1] = "Error2";

    try f.check(true, true);
}

test "native label permits uppercase abbreviation and digits" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.native] = "HTTP2";

    try f.check(true, true);
}

test "optional can contain an earlier native reference" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .optional = F.id(f.ids.native) });

    try f.check(true, true);
}

test "list can contain an earlier native reference" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .list = F.id(f.ids.native) });

    try f.check(true, true);
}

test "tuple can contain an earlier native reference" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .tuple = &.{F.id(f.ids.native)} });

    try f.check(true, true);
}

test "object can contain an earlier native reference" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .object = .{ .names = &.{"node"}, .types = &.{@intCast(f.ids.native)}, .len = 1 } });

    try f.check(true, true);
}
