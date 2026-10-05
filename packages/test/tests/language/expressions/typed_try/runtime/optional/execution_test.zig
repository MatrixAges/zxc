const check = @import("capture_check");

test "successful null remains null after outer result unwrap" {
    try check.output(1, null, 1);
}

test "failed optional call differs from successful null" {
    try check.output(0, 0, 1);
}

test "successful optional value retains its original payload" {
    try check.output(2, 2, 1);
}
