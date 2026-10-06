const check = @import("lifecycle_check");

test "scope exit cancels and joins an unawaited started worker" {
    try check.run(2, .{ .result = .{ .value = 2 } });
}

test "unawaited task business error does not replace the caller return value" {
    try check.run(0, .{ .result = .{ .value = 0 } });
}
