const check = @import("await_check");

test "nested local tasks return the inner successful payload" {
    try check.output(5, 5, .{});
}

test "nested local awaits propagate the inner error" {
    try check.failure(1, error.MissingValue, .{});
}
