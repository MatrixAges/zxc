const check = @import("support").check;

test "built_ins/list/callbacks/reduce/arguments/original_arguments" {
    try check(@import("program"), &.{.items = &.{11}, .seed = 1}, .{ .value = 2 });
}

test "built_ins/list/callbacks/reduce/arguments/wrong_seed" {
    try check(@import("program"), &.{.items = &.{11}, .seed = 2}, .{ .value = 0 });
}

test "built_ins/list/callbacks/reduce/arguments/wrong_item" {
    try check(@import("program"), &.{.items = &.{9}, .seed = 1}, .{ .value = 0 });
}

test "built_ins/list/callbacks/reduce/arguments/at_threshold" {
    try check(@import("program"), &.{.items = &.{10}, .seed = 1}, .{ .value = 0 });
}

test "built_ins/list/callbacks/reduce/arguments/empty" {
    try check(@import("program"), &.{.items = &.{}, .seed = 1}, .{ .value = 1 });
}

test "built_ins/list/callbacks/reduce/arguments/next_accumulator" {
    try check(@import("program"), &.{.items = &.{11, 12}, .seed = 1}, .{ .value = 0 });
}
