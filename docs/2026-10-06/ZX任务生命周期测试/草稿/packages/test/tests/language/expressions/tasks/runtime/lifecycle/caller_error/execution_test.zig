const check = @import("lifecycle_check");

test "caller error survives cleanup when its task returns a different business error" {
    try check.run(0, .{ .result = .{ .failure = error.OuterFailure }, .outer = 1 });
}
