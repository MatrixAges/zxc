const check = @import("support").check;

test "built_ins/list/nested/nested_map/empty_outer" {
    try check(@import("program"), &.{}, .{ .value = &.{} });
}

test "built_ins/list/nested/nested_map/empty_inner" {
    try check(@import("program"), &.{&.{}}, .{ .value = &.{&.{}} });
}

test "built_ins/list/nested/nested_map/two_empty_rows" {
    try check(@import("program"), &.{&.{}, &.{}}, .{ .value = &.{&.{}, &.{}} });
}

test "built_ins/list/nested/nested_map/single_zero" {
    try check(@import("program"), &.{&.{0}}, .{ .value = &.{&.{1}} });
}

test "built_ins/list/nested/nested_map/mixed_signs" {
    try check(@import("program"), &.{&.{-2, 0, 3}}, .{ .value = &.{&.{-1, 1, 4}} });
}

test "built_ins/list/nested/nested_map/empty_middle" {
    try check(@import("program"), &.{&.{1, 2}, &.{}, &.{-3, 4}}, .{ .value = &.{&.{2, 3}, &.{}, &.{-2, 5}} });
}

test "built_ins/list/nested/nested_map/varied_rows" {
    try check(@import("program"), &.{&.{2}, &.{3, 4}}, .{ .value = &.{&.{3}, &.{4, 5}} });
}
