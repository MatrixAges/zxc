const check = @import("support").check;

test "built_ins/list/callbacks/every/context/context_false/empty" {
    try check(@import("program"), &.{.items = &.{}, .context = &.{.res = false}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_false/single" {
    try check(@import("program"), &.{.items = &.{1}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_false/zero" {
    try check(@import("program"), &.{.items = &.{0}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_false/signed" {
    try check(@import("program"), &.{.items = &.{-11, 0, 11}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_false/repeated" {
    try check(@import("program"), &.{.items = &.{1, 1, 1}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_false/ordered" {
    try check(@import("program"), &.{.items = &.{1, 3, 2}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_false/reversed" {
    try check(@import("program"), &.{.items = &.{2, 3, 1}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_false/growth_17" {
    try check(@import("program"), &.{.items = &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_false/growth_65" {
    try check(@import("program"), &.{.items = &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_false/growth_257" {
    try check(@import("program"), &.{.items = &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8}, .context = &.{.res = false}}, .{ .value = false });
}

test "built_ins/list/callbacks/every/context/context_true/empty" {
    try check(@import("program"), &.{.items = &.{}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/single" {
    try check(@import("program"), &.{.items = &.{1}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/zero" {
    try check(@import("program"), &.{.items = &.{0}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/signed" {
    try check(@import("program"), &.{.items = &.{-11, 0, 11}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/repeated" {
    try check(@import("program"), &.{.items = &.{1, 1, 1}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/ordered" {
    try check(@import("program"), &.{.items = &.{1, 3, 2}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/reversed" {
    try check(@import("program"), &.{.items = &.{2, 3, 1}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/growth_17" {
    try check(@import("program"), &.{.items = &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/growth_65" {
    try check(@import("program"), &.{.items = &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7}, .context = &.{.res = true}}, .{ .value = true });
}

test "built_ins/list/callbacks/every/context/context_true/growth_257" {
    try check(@import("program"), &.{.items = &.{-11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, -11, -10, -9, -8}, .context = &.{.res = true}}, .{ .value = true });
}
