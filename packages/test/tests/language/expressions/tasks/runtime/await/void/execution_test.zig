const check = @import("await_check");

test "void await continues into the following native call" {
    try check.output(2, 3, .{ .total = 2 });
}

test "void await failure prevents the following native call" {
    try check.failure(0, error.NativeFailure, .{});
}
