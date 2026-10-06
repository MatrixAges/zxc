const check = @import("await_check");

test "await returns native scalar payload" {
    try check.output(7, 7, .{});
}

test "await propagates the first finite native error" {
    try check.failure(0, error.NativeFailure, .{});
}

test "await propagates a different finite native error" {
    try check.failure(1, error.MissingValue, .{});
}
