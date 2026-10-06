const check = @import("lifecycle_check");

test "leaving a nested block joins its task before the following outer call" {
    try check.run(2, .{ .result = .{ .value = 2 }, .after = 1 });
}
