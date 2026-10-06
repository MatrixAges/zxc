const check = @import("lifecycle_check");

test "cancel waits for uncancelable worker cleanup after cancellation acknowledgment" {
    try check.run(2, .{ .result = .{ .value = 2 }, .after = 1, .hold_cleanup = true });
}

test "uncancelable cleanup completes before the task business error is discarded" {
    try check.run(0, .{ .result = .{ .value = 0 }, .after = 1, .hold_cleanup = true });
}
