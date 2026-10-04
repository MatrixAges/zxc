const std = @import("std");
const h = @import("check.zig");

test "expression analyze plain" {
    try h.run(std.testing.allocator, false, .{ .source = "value", .bindings = &.{.{ .name = "value", .type_id = h.number }}, .expected = null, .code = null, .output = h.number });
}

test "expression analyze nested" {
    try h.run(std.testing.allocator, false, .{ .source = "$input.value", .bindings = &.{.{ .name = "$input.value", .type_id = h.number }}, .expected = null, .code = null, .output = h.number });
}

test "expression analyze siblings" {
    try h.run(std.testing.allocator, false, .{ .source = "$input.left + $input.right", .bindings = &.{ .{ .name = "$input.left", .type_id = h.number }, .{ .name = "$input.right", .type_id = h.number } }, .expected = null, .code = null, .output = h.number });
}

test "expression analyze prefix_not_ancestor" {
    try h.run(std.testing.allocator, false, .{ .source = "root.a + root.ab", .bindings = &.{ .{ .name = "root.a", .type_id = h.number }, .{ .name = "root.ab", .type_id = h.number } }, .expected = null, .code = null, .output = h.number });
}

test "expression analyze mixed_order" {
    try h.run(std.testing.allocator, false, .{ .source = "flag ? amount : 0", .bindings = &.{ .{ .name = "flag", .type_id = h.boolean }, .{ .name = "amount", .type_id = h.number } }, .expected = null, .code = null, .output = h.number });
}

test "expression analyze duplicate" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{ .{ .name = "item", .type_id = h.number }, .{ .name = "item", .type_id = h.number } }, .expected = null, .code = .name, .output = h.number });
}

test "expression analyze ancestor_first" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{ .{ .name = "item", .type_id = h.number }, .{ .name = "item.child", .type_id = h.number } }, .expected = null, .code = .name, .output = h.number });
}

test "expression analyze descendant_first" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{ .{ .name = "item.child", .type_id = h.number }, .{ .name = "item", .type_id = h.number } }, .expected = null, .code = .name, .output = h.number });
}

test "expression analyze empty" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{.{ .name = "", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression analyze empty_segment" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{.{ .name = "a..b", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression analyze keyword_segment" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{.{ .name = "a.return", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression analyze numeric_segment" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{.{ .name = "a.1", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression analyze void" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{.{ .name = "a", .type_id = @enumFromInt(0) }}, .expected = null, .code = .type_mismatch, .output = h.number });
}

test "expression analyze missing_type" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{.{ .name = "a", .type_id = @enumFromInt(99) }}, .expected = null, .code = .contract, .output = h.number });
}

test "expression analyze missing_expected" {
    try h.run(std.testing.allocator, false, .{ .source = "7", .bindings = &.{}, .expected = @enumFromInt(99), .code = .contract, .output = h.number });
}

test "expression analyze wrong_expected" {
    try h.run(std.testing.allocator, false, .{ .source = "true", .bindings = &.{}, .expected = h.number, .code = .type_mismatch, .output = h.number });
}

test "expression analyze missing_path" {
    try h.run(std.testing.allocator, false, .{ .source = "root.other", .bindings = &.{.{ .name = "root.value", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression analyze bool_expected" {
    try h.run(std.testing.allocator, false, .{ .source = "flag", .bindings = &.{.{ .name = "flag", .type_id = h.boolean }}, .expected = h.boolean, .code = null, .output = h.boolean });
}

test "expression analyze success allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{ false, h.Case{ .source = "$input.value", .bindings = &.{.{ .name = "$input.value", .type_id = h.number }}, .expected = h.number } });
}

test "expression analyze reject allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{ false, h.Case{ .source = "$input.value", .bindings = &.{.{ .name = "$input.value", .type_id = h.number }}, .expected = h.boolean, .code = .type_mismatch } });
}

test "expression compile plain" {
    try h.run(std.testing.allocator, true, .{ .source = "value", .bindings = &.{.{ .name = "value", .type_id = h.number }}, .expected = null, .code = null, .output = h.number });
}

test "expression compile nested" {
    try h.run(std.testing.allocator, true, .{ .source = "$input.value", .bindings = &.{.{ .name = "$input.value", .type_id = h.number }}, .expected = null, .code = null, .output = h.number });
}

test "expression compile siblings" {
    try h.run(std.testing.allocator, true, .{ .source = "$input.left + $input.right", .bindings = &.{ .{ .name = "$input.left", .type_id = h.number }, .{ .name = "$input.right", .type_id = h.number } }, .expected = null, .code = null, .output = h.number });
}

test "expression compile prefix_not_ancestor" {
    try h.run(std.testing.allocator, true, .{ .source = "root.a + root.ab", .bindings = &.{ .{ .name = "root.a", .type_id = h.number }, .{ .name = "root.ab", .type_id = h.number } }, .expected = null, .code = null, .output = h.number });
}

test "expression compile mixed_order" {
    try h.run(std.testing.allocator, true, .{ .source = "flag ? amount : 0", .bindings = &.{ .{ .name = "flag", .type_id = h.boolean }, .{ .name = "amount", .type_id = h.number } }, .expected = null, .code = null, .output = h.number });
}

test "expression compile duplicate" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{ .{ .name = "item", .type_id = h.number }, .{ .name = "item", .type_id = h.number } }, .expected = null, .code = .name, .output = h.number });
}

test "expression compile ancestor_first" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{ .{ .name = "item", .type_id = h.number }, .{ .name = "item.child", .type_id = h.number } }, .expected = null, .code = .name, .output = h.number });
}

test "expression compile descendant_first" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{ .{ .name = "item.child", .type_id = h.number }, .{ .name = "item", .type_id = h.number } }, .expected = null, .code = .name, .output = h.number });
}

test "expression compile empty" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{.{ .name = "", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression compile empty_segment" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{.{ .name = "a..b", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression compile keyword_segment" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{.{ .name = "a.return", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression compile numeric_segment" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{.{ .name = "a.1", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression compile void" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{.{ .name = "a", .type_id = @enumFromInt(0) }}, .expected = null, .code = .type_mismatch, .output = h.number });
}

test "expression compile missing_type" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{.{ .name = "a", .type_id = @enumFromInt(99) }}, .expected = null, .code = .contract, .output = h.number });
}

test "expression compile missing_expected" {
    try h.run(std.testing.allocator, true, .{ .source = "7", .bindings = &.{}, .expected = @enumFromInt(99), .code = .contract, .output = h.number });
}

test "expression compile wrong_expected" {
    try h.run(std.testing.allocator, true, .{ .source = "true", .bindings = &.{}, .expected = h.number, .code = .type_mismatch, .output = h.number });
}

test "expression compile missing_path" {
    try h.run(std.testing.allocator, true, .{ .source = "root.other", .bindings = &.{.{ .name = "root.value", .type_id = h.number }}, .expected = null, .code = .name, .output = h.number });
}

test "expression compile bool_expected" {
    try h.run(std.testing.allocator, true, .{ .source = "flag", .bindings = &.{.{ .name = "flag", .type_id = h.boolean }}, .expected = h.boolean, .code = null, .output = h.boolean });
}

test "expression compile success allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{ true, h.Case{ .source = "$input.value", .bindings = &.{.{ .name = "$input.value", .type_id = h.number }}, .expected = h.number } });
}

test "expression compile reject allocation failures" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{ true, h.Case{ .source = "$input.value", .bindings = &.{.{ .name = "$input.value", .type_id = h.number }}, .expected = h.boolean, .code = .type_mismatch } });
}
