const check = @import("lifecycle_check");

test "direct cancel async completes its worker before the next call" {
    try check.run(2, .{ .result = .{ .value = 2 }, .after = 1 });
}

test "direct cancel async discards the canceled worker business error" {
    try check.run(0, .{ .result = .{ .value = 0 }, .after = 1 });
}
