const check = @import("support").check;

test "built_ins/list/callbacks/every/rows/empty" {
    try check(@import("program"), &.{.items = &.{}, .threshold = 10}, .{ .value = &.{.result = true, .calls = 0, .visited = &.{}, .threshold = 10} });
}

test "built_ins/list/callbacks/every/rows/true" {
    try check(@import("program"), &.{.items = &.{&.{11}}, .threshold = 10}, .{ .value = &.{.result = true, .calls = 1, .visited = &.{11}, .threshold = 10} });
}

test "built_ins/list/callbacks/every/rows/false" {
    try check(@import("program"), &.{.items = &.{&.{9}}, .threshold = 10}, .{ .value = &.{.result = false, .calls = 1, .visited = &.{9}, .threshold = 10} });
}

test "built_ins/list/callbacks/every/rows/first_failure" {
    try check(@import("program"), &.{.items = &.{&.{}}, .threshold = 10}, .{ .failure = error.IndexOutOfBounds });
}

test "built_ins/list/callbacks/every/rows/later_failure" {
    try check(@import("program"), &.{.items = &.{&.{11}, &.{}}, .threshold = 10}, .{ .failure = error.IndexOutOfBounds });
}

test "built_ins/list/callbacks/every/rows/stopped_before_empty" {
    try check(@import("program"), &.{.items = &.{&.{9}, &.{}}, .threshold = 10}, .{ .value = &.{.result = false, .calls = 1, .visited = &.{9}, .threshold = 10} });
}

test "built_ins/list/callbacks/every/rows/stopped_after_true" {
    try check(@import("program"), &.{.items = &.{&.{11}, &.{9}, &.{}}, .threshold = 10}, .{ .value = &.{.result = false, .calls = 2, .visited = &.{11, 9}, .threshold = 10} });
}

test "built_ins/list/callbacks/every/rows/all_true" {
    try check(@import("program"), &.{.items = &.{&.{11}, &.{12}, &.{13}}, .threshold = 10}, .{ .value = &.{.result = true, .calls = 3, .visited = &.{11, 12, 13}, .threshold = 10} });
}
