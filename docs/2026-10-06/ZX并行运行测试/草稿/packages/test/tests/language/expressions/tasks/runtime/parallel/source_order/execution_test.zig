const check = @import("parallel_check");

test "source first error wins even when the second branch finishes first" {
    try check.run(3, .{ .result = .{ .failure = error.FirstFailure } });
}

test "a successful first branch leaves the later finite error visible" {
    try check.run(2, .{ .result = .{ .failure = error.SecondFailure } });
}
