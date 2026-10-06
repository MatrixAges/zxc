const check = @import("await_check");

test "try await scalar success exposes the correlated result" {
    try check.output(4, 4, .{});
}

test "try await scalar compares its first finite error member" {
    try check.output(0, 10, .{});
}

test "try await scalar distinguishes its second finite error member" {
    try check.output(1, 11, .{});
}
