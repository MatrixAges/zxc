const check = @import("support").check;

test "built_ins/list/callbacks/map/predicate/original_length" {
    try check(@import("program"), &.{12, 11}, .{ .value = &.{true, true} });
}

test "built_ins/list/callbacks/map/predicate/original_values" {
    try check(@import("program"), &.{11, 9}, .{ .value = &.{true, false} });
}

test "built_ins/list/callbacks/map/predicate/empty" {
    try check(@import("program"), &.{}, .{ .value = &.{} });
}

test "built_ins/list/callbacks/map/predicate/at_threshold" {
    try check(@import("program"), &.{10}, .{ .value = &.{false} });
}

test "built_ins/list/callbacks/map/predicate/above_threshold" {
    try check(@import("program"), &.{11}, .{ .value = &.{true} });
}

test "built_ins/list/callbacks/map/predicate/mixed" {
    try check(@import("program"), &.{-1, 0, 10, 11, 12}, .{ .value = &.{false, false, false, true, true} });
}

test "built_ins/list/callbacks/map/predicate/repeated" {
    try check(@import("program"), &.{12, 12, 9}, .{ .value = &.{true, true, false} });
}
