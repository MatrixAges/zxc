const check = @import("check.zig");
const ordered: []const i64 = &.{ 0, 1, 2, 3, 4, 5 };
const unrelated: []const i64 = &.{ 99, -8, 44, 0, 12, 12, -5, 7, 1, 900 };

test "empty callbacks evaluate the source once without invoking the callback" {
    try check.execute(.{ .values = &.{}, .failure = 1 });
}

test "singleton callbacks receive zero index and the original source" {
    try check.execute(.{ .values = &.{11} });
}

test "callback arguments preserve Test262 ascending indices and call counts" {
    try check.execute(.{ .values = ordered, .rule = if (check.method == .some) .none else .all });
}

test "callback indices remain independent of repeated and unordered values" {
    try check.execute(.{ .values = unrelated, .rule = if (check.method == .some) .none else .all });
}

test "callback source identity and full length survive predicate short circuit" {
    try check.execute(.{ .values = &.{ 1, 0, 3 }, .rule = .positive });
    try check.execute(.{ .values = &.{ 0, 1, 0 }, .rule = .positive });
    try check.execute(.{ .values = &.{ -1, 0, 1 }, .rule = .positive });
}

test "callback index predicates observe zero and interior boundaries" {
    for ([_]usize{ 0, 1, 5, 9, 10, 11 }) |limit| {
        try check.execute(.{ .values = unrelated, .rule = .before, .limit = limit });
    }
}

test "callback failure stops exactly at every reachable visit" {
    for (1..ordered.len + 2) |failure| {
        try check.execute(.{ .values = ordered, .rule = if (check.method == .some) .none else .all, .failure = failure });
        try check.execute(.{ .values = ordered, .rule = .before, .limit = 3, .failure = failure });
    }
}

test "callback parameter bindings reset across independent executions" {
    for (0..17) |_| {
        try check.execute(.{ .values = unrelated });
        try check.execute(.{ .values = &.{7}, .rule = .none });
        try check.execute(.{ .values = &.{} });
    }
}

test "long traversal retains exact indices and the complete borrowed source" {
    var values: [4096]i64 = undefined;

    for (&values, 0..) |*value, index| value.* = @as(i64, @intCast(index % 23)) - 11;
    try check.execute(.{ .values = &values, .rule = if (check.method == .some) .none else .all });
}
