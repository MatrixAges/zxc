const check = @import("capture_check");

test "capture encloses the whole compound expression" {
    try check.output(2, 4, 2);
}

test "compound capture stops at the first NativeFailure" {
    try check.output(0, 0, 1);
}

test "compound capture stops at the first MissingValue" {
    try check.output(1, 0, 1);
}
