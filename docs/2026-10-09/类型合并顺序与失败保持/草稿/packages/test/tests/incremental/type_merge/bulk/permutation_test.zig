const multiple = @import("multiple.zig");

test "three full graphs preserve sharing in every module order" {
    try multiple.permutations(.none, .{}, 0);
}

test "tuple child changes propagate through every module order" {
    try multiple.permutations(.tuple_tail, .{ .pair = false, .saved = false, .list = false, .record = false, .task = false }, 5);
}

test "object field names remain distinct in every module order" {
    try multiple.permutations(.object_name, .{ .record = false, .task = false }, 2);
}

test "object field types remain distinct in every module order" {
    try multiple.permutations(.object_type, .{ .record = false, .task = false }, 2);
}

test "error members propagate to task types in every module order" {
    try multiple.permutations(.errors, .{ .errors = false, .task = false }, 2);
}

test "task result changes remain distinct in every module order" {
    try multiple.permutations(.task_result, .{ .task = false }, 1);
}

test "task error changes remain distinct in every module order" {
    try multiple.permutations(.task_errors, .{ .task = false }, 2);
}

test "container kind changes propagate through every module order" {
    try multiple.permutations(.plain_kind, .{ .plain = false, .record = false, .task = false }, 3);
}
