const check = @import("capture_check");

test "successful captured void call executes once" {
    try check.output(2, 2, 1);
}

test "failed captured void call executes once and exposes its error" {
    try check.output(0, 0, 1);
}
