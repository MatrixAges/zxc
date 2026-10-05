const check = @import("capture_check");

test "ordinary failure before capture propagates and skips capture" {
    try check.failure(0, error.NativeFailure, 1);
}

test "another ordinary error before capture retains its member" {
    try check.failure(1, error.MissingValue, 1);
}

test "successful ordinary call continues into the later capture" {
    try check.output(2, 2, 2);
}
