const check = @import("await_check");

test "task allocated list result survives await until application arena release" {
    try check.output(6, &.{ 6, 7 }, .{});
}

test "task list native operand failure propagates without a partial result" {
    try check.failure(0, error.NativeFailure, .{});
}
