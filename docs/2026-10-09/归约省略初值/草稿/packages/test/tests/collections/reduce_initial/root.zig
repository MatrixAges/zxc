const check = @import("check.zig");
const Value = check.Value;
const one = if (check.text) "initialValue is not present" else 11;
const pair: []const Value = if (check.text) &.{ "first", "second" } else &.{ 11, 9 };
const ordered: []const Value = if (check.text) &.{ "alpha", "beta", "gamma", "delta" } else &.{ 3, -1, 7, 0 };

test "empty reduce distinguishes a missing initial from an explicit initial" {
    try check.execute(.{ .values = &.{} });
    try check.execute(.{ .values = &.{}, .failure = .callback, .fail_at = 1 });
}

test "singleton reduce skips the callback only when the initial is absent" {
    try check.execute(.{ .values = &.{one} });
    try check.execute(.{ .values = &.{one}, .failure = .callback, .fail_at = 1 });
}

test "first reduce callback receives the proper accumulator current and index" {
    try check.execute(.{ .values = pair });
}

test "reduce callbacks preserve source identity and ascending indices" {
    try check.execute(.{ .values = ordered });
}

test "reduce initialization is repeated for independent executions" {
    for (0..17) |_| {
        try check.execute(.{ .values = pair });
        try check.execute(.{ .values = &.{one} });
    }
}

test "reduce source and seed failures precede callback execution" {
    for ([_][]const Value{ &.{}, &.{one}, pair, ordered }) |values| {
        try check.execute(.{ .values = values, .failure = .source });
        try check.execute(.{ .values = values, .failure = .seed });
    }
}

test "reduce propagates every reachable callback failure without later calls" {
    for (1..ordered.len + 2) |boundary| try check.execute(.{ .values = ordered, .failure = .callback, .fail_at = boundary });
}

test "long reduce traversal preserves inputs and exact callback observations" {
    var values: [4096]Value = undefined;

    for (&values, 0..) |*value, index| value.* = if (check.text) (if (index % 2 == 0) "alpha" else "omega") else @as(i64, @intCast(index % 23)) - 11;

    try check.execute(.{ .values = &values });
}
