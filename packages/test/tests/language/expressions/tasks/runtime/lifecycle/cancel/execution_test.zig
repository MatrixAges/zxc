const check = @import("lifecycle_check");

test "explicit cancel waits for a started cancelable worker" {
    try check.run(2, .{ .result = .{ .value = 2 }, .after = 1 });
}

test "explicit cancel discards the worker business error after cancellation" {
    try check.run(0, .{ .result = .{ .value = 0 }, .after = 1 });
}
