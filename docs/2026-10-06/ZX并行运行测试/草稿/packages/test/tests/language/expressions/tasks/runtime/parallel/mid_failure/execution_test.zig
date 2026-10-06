const check = @import("parallel_check");

test "later concurrency startup failure cancels and joins the already started branch" {
    try check.run(0, .{ .result = .{ .value = 99 }, .source_tags = &.{1}, .reverse_completion = false, .fail_at = 2, .awaits = 0, .cancels = 1, .canceled = 1, .overlap = 0 });
}
