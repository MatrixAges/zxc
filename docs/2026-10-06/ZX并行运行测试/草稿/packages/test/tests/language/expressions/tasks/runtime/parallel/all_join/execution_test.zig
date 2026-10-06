const check = @import("parallel_check");

test "first branch error still awaits the later branch without canceling it" {
    try check.run(1, .{ .result = .{ .failure = error.FirstFailure }, .reverse_completion = false, .release_on_await = true });
}
