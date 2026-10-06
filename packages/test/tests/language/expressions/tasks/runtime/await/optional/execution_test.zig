const check = @import("await_check");

test "try await keeps successful null separate from failed optional" {
    try check.output(1, null, .{});
}

test "try await optional failure follows its error branch" {
    try check.output(0, 0, .{});
}

test "try await optional success unwraps only the capture layer" {
    try check.output(3, 3, .{});
}
