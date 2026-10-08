const check = @import("support").check;

test "built_ins/list/callbacks/reduce/empty/original_no_callback" {
    try check(@import("program"), &.{.items = &.{}, .seed = 3}, .{ .value = 3 });
}

test "built_ins/list/callbacks/reduce/empty/original_seed" {
    try check(@import("program"), &.{.items = &.{}, .seed = 1}, .{ .value = 1 });
}

test "built_ins/list/callbacks/reduce/empty/zero_seed" {
    try check(@import("program"), &.{.items = &.{}, .seed = 0}, .{ .value = 0 });
}

test "built_ins/list/callbacks/reduce/empty/negative_seed" {
    try check(@import("program"), &.{.items = &.{}, .seed = -2}, .{ .value = -2 });
}

test "built_ins/list/callbacks/reduce/empty/nonempty_success" {
    try check(@import("program"), &.{.items = &.{&.{2}, &.{5}}, .seed = 3}, .{ .value = 10 });
}

test "built_ins/list/callbacks/reduce/empty/nonempty_failure" {
    try check(@import("program"), &.{.items = &.{&.{}}, .seed = 3}, .{ .failure = error.IndexOutOfBounds });
}

test "built_ins/list/callbacks/reduce/empty/later_failure" {
    try check(@import("program"), &.{.items = &.{&.{2}, &.{}}, .seed = 3}, .{ .failure = error.IndexOutOfBounds });
}

test "built_ins/list/callbacks/reduce/empty/zero_element" {
    try check(@import("program"), &.{.items = &.{&.{0}}, .seed = 3}, .{ .value = 3 });
}

test "built_ins/list/callbacks/reduce/empty/first_field" {
    try check(@import("program"), &.{.items = &.{&.{0, 9}}, .seed = 3}, .{ .value = 3 });
}
