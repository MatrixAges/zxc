const check = @import("lifecycle_check");

test "cancel of an already successful task keeps its completion without a cancel acknowledgment" {
    try check.run(2, .{ .result = .{ .value = 2 }, .after = 1, .canceled = 0, .completed_start = true });
    try check.run(2, .{ .result = .{ .value = 2 }, .mode = .inline_execution, .after = 1, .canceled = 0, .completed_start = true });
}

test "cancel of an already failed task discards its business error in both execution paths" {
    try check.run(0, .{ .result = .{ .value = 0 }, .after = 1, .canceled = 0, .completed_start = true });
    try check.run(0, .{ .result = .{ .value = 0 }, .mode = .inline_execution, .after = 1, .canceled = 0, .completed_start = true });
}
