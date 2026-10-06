const check = @import("parallel_check");

test "try parallel exposes correlated named results after every branch await" {
    try check.run(0, .{ .result = .{ .value = 1020 } });
}

test "try parallel captures the first branch finite error" {
    try check.run(1, .{ .result = .{ .value = 100 } });
}

test "try parallel captures the second branch finite error after first success" {
    try check.run(2, .{ .result = .{ .value = 200 } });
}
