const check = @import("capture_check");

test "captured initial failure prevents the later ordinary call" {
    try check.output(0, 999, 1);
}

test "ordinary failure after capture remains outside its boundary" {
    try check.failure(2, error.NativeFailure, 2);
}

test "ordinary second member after capture continues to propagate" {
    try check.failure(3, error.MissingValue, 2);
}

test "successful capture continues to the ordinary result" {
    try check.output(4, 2, 2);
}
