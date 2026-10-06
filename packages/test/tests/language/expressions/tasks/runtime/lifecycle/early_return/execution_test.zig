const check = @import("lifecycle_check");

test "early branch return joins its pending task and keeps the selected value" {
    try check.run(0, .{ .result = .{ .value = 23 } });
}
