const check = @import("capture_check");

test "captured empty list index exposes IndexOutOfBounds" {
    try check.output(&.{}, 133, 0);
}

test "captured zero list element is a successful present result" {
    try check.output(&.{0}, 0, 0);
}

test "captured list index returns only the selected element" {
    try check.output(&.{ 7, 9 }, 7, 0);
}
