const check = @import("parallel_check");

test "mixed void branch runs concurrently without occupying a named result field" {
    try check.run(0, .{ .result = .{ .value = 1020 }, .source_tags = &.{ 1, 3, 2 }, .branches = 3 });
}

test "void branch error preserves its source position before a later scalar error" {
    try check.run(10, .{ .result = .{ .failure = error.EffectFailure }, .source_tags = &.{ 1, 3, 2 }, .branches = 3 });
}
