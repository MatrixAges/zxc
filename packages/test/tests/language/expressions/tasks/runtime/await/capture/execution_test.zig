const check = @import("await_check");

test "await reads captured locals in their actual operand order" {
    try check.output(4, 20, .{});
}
