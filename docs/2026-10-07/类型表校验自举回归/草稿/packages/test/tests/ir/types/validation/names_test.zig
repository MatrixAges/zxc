const std = @import("std");
const F = @import("fixture.zig");

test "native label empty violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.native] = "";

    try f.check(false, true);
}

test "native label lowercase violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.native] = "node";

    try f.check(false, true);
}

test "native label underscore violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.native] = "Node_Value";

    try f.check(false, true);
}

test "native label punctuation violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.native] = "Node-Value";

    try f.check(false, true);
}

test "native label nul violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.native] = "Node\x00Value";

    try f.check(false, true);
}

test "native label unicode violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.native] = "节";

    try f.check(false, true);
}

test "later error member empty violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.errors] + 1] = "";

    try f.check(false, true);
}

test "later error member lowercase violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.errors] + 1] = "zeta";

    try f.check(false, true);
}

test "later error member underscore violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.errors] + 1] = "Zeta_Value";

    try f.check(false, true);
}

test "later error member nul violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.errors] + 1] = "Zeta\x00Value";

    try f.check(false, true);
}

test "later error member unicode violates type naming" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.errors] + 1] = "节";

    try f.check(false, true);
}

test "error members must be strictly byte ascending" {
    var f = try F.init();

    defer f.deinit();
    std.mem.swap([]const u8, &f.storage.names.items[f.storage.first.items[f.ids.errors]], &f.storage.names.items[f.storage.first.items[f.ids.errors] + 1]);

    try f.check(false, true);
}

test "duplicate error members are rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.errors] + 1] = "Alpha";

    try f.check(false, true);
}

test "enumeration label cannot be empty" {
    var f = try F.init();

    defer f.deinit();

    f.storage.labels.items[f.ids.enumeration] = "";

    try f.check(false, true);
}

test "enumeration must have at least one member" {
    var f = try F.init();

    defer f.deinit();

    _ = try f.add(.{ .enumeration = .{ .name = "Empty", .members = &.{} } });

    try f.check(false, true);
}

test "later enumeration member cannot be empty" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.enumeration] + 1] = "";

    try f.check(false, true);
}

test "nonadjacent duplicate enumeration member is rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.names.items[f.storage.first.items[f.ids.enumeration] + 2] = "Zeta";

    try f.check(false, true);
}

test "later object field name cannot be empty" {
    var f = try F.init();

    defer f.deinit();

    f.storage.field_names.items[f.storage.first.items[f.ids.object] + 1] = "";

    try f.check(false, true);
}

test "duplicate object field names are rejected" {
    var f = try F.init();

    defer f.deinit();

    f.storage.field_names.items[f.storage.first.items[f.ids.object] + 1] = "alpha";

    try f.check(false, true);
}

test "object fields must be strictly byte ascending" {
    var f = try F.init();

    defer f.deinit();
    std.mem.swap([]const u8, &f.storage.field_names.items[f.storage.first.items[f.ids.object]], &f.storage.field_names.items[f.storage.first.items[f.ids.object] + 1]);

    try f.check(false, true);
}
