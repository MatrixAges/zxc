const check = @import("await_check");

test "direct await async returns native scalar result" {
    try check.output(9, 9, .{});
}

test "direct await async propagates native failure" {
    try check.failure(0, error.NativeFailure, .{});
}
