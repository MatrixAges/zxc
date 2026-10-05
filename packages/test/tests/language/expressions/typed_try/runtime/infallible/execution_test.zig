const std = @import("std");
const check = @import("capture_check");

test "capturing infallible zero succeeds with a present result" {
    try check.output(0, 0, 1);
}

test "capturing infallible maximum preserves all bits" {
    try check.output(std.math.maxInt(u64), std.math.maxInt(u64), 1);
}
