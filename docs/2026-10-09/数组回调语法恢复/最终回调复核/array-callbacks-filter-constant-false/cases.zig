const check = @import("support").check;

test "built_ins/list/callbacks/filter/constant_false/empty" {
    try check(@import("program"), &.{}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/single" {
    try check(@import("program"), &.{11}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/zero" {
    try check(@import("program"), &.{0}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/signed" {
    try check(@import("program"), &.{-11, 0, 11}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/repeated" {
    try check(@import("program"), &.{11, 11, 11}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/ordered" {
    try check(@import("program"), &.{11, 9, 12}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/reversed" {
    try check(@import("program"), &.{12, 9, 11}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/growth_17" {
    try check(@import("program"), &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/growth_65" {
    try check(@import("program"), &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/constant_false/growth_257" {
    try check(@import("program"), &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8}, .{ .value = &.{} });
}
