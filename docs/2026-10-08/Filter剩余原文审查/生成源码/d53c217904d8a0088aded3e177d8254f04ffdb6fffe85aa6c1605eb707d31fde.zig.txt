const check = @import("support").check;

test "built_ins/list/callbacks/filter/predicate/original_single_parameter" {
    try check(@import("program"), &.{12}, .{ .value = &.{12} });
}

test "built_ins/list/callbacks/filter/predicate/empty" {
    try check(@import("program"), &.{}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/predicate/all_rejected" {
    try check(@import("program"), &.{-1, 0, 9, 10}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/filter/predicate/all_retained" {
    try check(@import("program"), &.{12, 11, 13}, .{ .value = &.{12, 11, 13} });
}

test "built_ins/list/callbacks/filter/predicate/threshold" {
    try check(@import("program"), &.{10, 11}, .{ .value = &.{11} });
}

test "built_ins/list/callbacks/filter/predicate/mixed_order" {
    try check(@import("program"), &.{12, 9, 11, 10, 13}, .{ .value = &.{12, 11, 13} });
}

test "built_ins/list/callbacks/filter/predicate/reverse_order" {
    try check(@import("program"), &.{13, 10, 11, 9, 12}, .{ .value = &.{13, 11, 12} });
}

test "built_ins/list/callbacks/filter/predicate/repeated" {
    try check(@import("program"), &.{11, 9, 11, 12, 11}, .{ .value = &.{11, 11, 12, 11} });
}

test "built_ins/list/callbacks/filter/predicate/negative_boundary" {
    try check(@import("program"), &.{-11, -10, 10, 11}, .{ .value = &.{11} });
}
