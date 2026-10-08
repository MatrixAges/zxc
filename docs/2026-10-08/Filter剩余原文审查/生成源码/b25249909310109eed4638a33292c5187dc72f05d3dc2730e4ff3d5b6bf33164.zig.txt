const check = @import("support").check;

test "built_ins/list/callbacks/reduce/order/original_order" {
    try check(@import("program"), &.{.items = &.{"1", "2", "3", "4", "5"}, .seed = "0"}, .{ .value = "012345" });
}

test "built_ins/list/callbacks/reduce/order/reversed" {
    try check(@import("program"), &.{.items = &.{"5", "4", "3", "2", "1"}, .seed = "0"}, .{ .value = "054321" });
}

test "built_ins/list/callbacks/reduce/order/empty" {
    try check(@import("program"), &.{.items = &.{}, .seed = "seed"}, .{ .value = "seed" });
}

test "built_ins/list/callbacks/reduce/order/empty_element" {
    try check(@import("program"), &.{.items = &.{"a", "", "b"}, .seed = "0"}, .{ .value = "0ab" });
}

test "built_ins/list/callbacks/reduce/order/unicode" {
    try check(@import("program"), &.{.items = &.{"\xe4\xb8\xad", "\xf0\x9f\x8c\xbf"}, .seed = ""}, .{ .value = "\xe4\xb8\xad\xf0\x9f\x8c\xbf" });
}

test "built_ins/list/callbacks/reduce/order/repeated" {
    try check(@import("program"), &.{.items = &.{"1", "1", "2"}, .seed = "0"}, .{ .value = "0112" });
}

test "built_ins/list/callbacks/reduce/order/all_empty" {
    try check(@import("program"), &.{.items = &.{"", ""}, .seed = "prefix"}, .{ .value = "prefix" });
}
