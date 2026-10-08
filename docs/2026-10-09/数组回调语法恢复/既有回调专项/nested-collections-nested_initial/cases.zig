const check = @import("support").check;

test "built_ins/list/nested/nested_initial/empty_outer" {
    try check(@import("program"), &.{}, .{ .value = &.{} });
}

test "built_ins/list/nested/nested_initial/empty_inner" {
    try check(@import("program"), &.{&.{}}, .{ .failure = error.IndexOutOfBounds });
}

test "built_ins/list/nested/nested_initial/two_empty_rows" {
    try check(@import("program"), &.{&.{}, &.{}}, .{ .failure = error.IndexOutOfBounds });
}

test "built_ins/list/nested/nested_initial/single_zero" {
    try check(@import("program"), &.{&.{0}}, .{ .value = &.{0} });
}

test "built_ins/list/nested/nested_initial/mixed_signs" {
    try check(@import("program"), &.{&.{-2, 0, 3}}, .{ .value = &.{-1} });
}

test "built_ins/list/nested/nested_initial/empty_middle" {
    try check(@import("program"), &.{&.{1, 2}, &.{}, &.{-3, 4}}, .{ .failure = error.IndexOutOfBounds });
}

test "built_ins/list/nested/nested_initial/varied_rows" {
    try check(@import("program"), &.{&.{2}, &.{3, 4}}, .{ .value = &.{4, 10} });
}
