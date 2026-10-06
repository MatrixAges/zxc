const check = @import("parallel_check");

test "parallel reports real zero concurrency capacity without starting a worker" {
    try check.run(0, .{ .result = .{ .value = 99 }, .source_tags = &.{}, .reverse_completion = false, .unavailable = true, .attempts = 1, .awaits = 0, .overlap = 0 });
}
