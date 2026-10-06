const check = @import("parallel_check");

test "parallel starts source ordered branches concurrently and maps canonical fields by name" {
    try check.run(0, .{ .result = .{ .value = 1020 } });
    try check.run(4, .{ .result = .{ .value = 1424 } });
}
