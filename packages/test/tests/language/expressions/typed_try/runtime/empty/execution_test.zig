const std = @import("std");
const check = @import("capture_check");

test "capturing empty throws zero succeeds with a present result" {
    try check.output(0, 0, 1);
}

test "capturing empty throws maximum preserves all bits" {
    try check.output(std.math.maxInt(u64), std.math.maxInt(u64), 1);
}
