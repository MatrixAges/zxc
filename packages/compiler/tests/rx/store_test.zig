const std = @import("std");
const rx = @import("rx");
const h = @import("helpers.zig");

fn field() rx.ast.Node {
    return h.node("Field", .{ .name = "cursor", .type = "u64", .value = "0" }, &.{});
}

test "store object and field definitions produce typed version" {
    const root = h.node("Store", .{ .name = "scheduler", .version = "1" }, &.{h.node("Object", .{ .name = "dispatcher" }, &.{field()})});
    var result = try rx.validate(std.testing.allocator, "scheduler.store.rx", root);

    defer result.deinit();

    try std.testing.expect(result.value == .data);
    try std.testing.expectEqual(@as(u32, 1), result.value.data.store.attributes.version);
    try std.testing.expectEqualStrings("u64", result.value.data.store.children[0].children[0].attributes.type);
}

test "store distinguishes references from definitions and validates version" {
    _ = try h.expectError("app.store.rx", h.node("Store", .{ .from = "scheduler" }, &.{}), .unknown_attribute);
    _ = try h.expectError("orders.rx", h.module(&.{h.node("Store", .{ .name = "scheduler", .version = "1" }, &.{})}), .unknown_attribute);
    _ = try h.expectError("app.store.rx", h.node("Store", .{ .name = "app", .version = "-1" }, &.{}), .invalid_attribute);
    _ = try h.expectError("app.store.rx", h.node("Store", .{ .name = "app", .version = "4294967296" }, &.{}), .invalid_attribute);
}

test "store rejects duplicate field names and wrong nesting" {
    const duplicate = h.node("Object", .{ .name = "dispatcher" }, &.{ field(), field() });
    _ = try h.expectError("app.store.rx", h.node("Store", .{ .name = "app", .version = "1" }, &.{duplicate}), .context);
    _ = try h.expectError("app.store.rx", h.node("Store", .{ .name = "app", .version = "1" }, &.{field()}), .unexpected_element);
}

test "string fields may have an empty initial value" {
    const empty = h.node("Field", .{ .name = "label", .type = "string", .value = "" }, &.{});

    try h.expectValid("app.store.rx", h.node("Store", .{ .name = "app", .version = "1" }, &.{h.node("Object", .{ .name = "state" }, &.{empty})}));
}

test "same object fragments allow disjoint fields but reject duplicate full paths" {
    const first = h.node("Object", .{ .name = "state" }, &.{field()});
    const second = h.node("Object", .{ .name = "state" }, &.{h.node("Field", .{ .name = "label", .type = "string", .value = "" }, &.{})});

    try h.expectValid("app.store.rx", h.node("Store", .{ .name = "app", .version = "1" }, &.{ first, second }));

    const issue = try h.expectError("app.store.rx", h.node("Store", .{ .name = "app", .version = "1" }, &.{ first, first }), .context);

    try std.testing.expectEqualStrings("Field", issue.element);
    try std.testing.expectEqualDeep(h.value_location, issue.location);
}
