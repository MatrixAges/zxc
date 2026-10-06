const check = @import("parallel_check");

test "all void parallel executes both effects then continues the caller" {
    try check.run(0, .{ .result = .{ .value = 0 }, .source_tags = &.{ 3, 3 }, .reverse_completion = false });
}

test "all void parallel waits both effects before propagating their finite error" {
    try check.run(8, .{ .result = .{ .failure = error.EffectFailure }, .source_tags = &.{ 3, 3 }, .reverse_completion = false });
}
