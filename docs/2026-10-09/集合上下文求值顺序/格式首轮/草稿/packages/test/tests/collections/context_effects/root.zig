const check = @import("check.zig");
const method = check.method;

const samples = [_][]const i64{
    &.{}, &.{0}, &.{1}, &.{-1}, &.{ 1, 0, 3 }, &.{ 0, 1, 0 }, &.{ -1, 0, 1 }, &.{ 1, 1, 1 }, &.{ 9, 7, 9, -1 },
};

test "explicit context evaluates once even for empty input" {
    try check.execute(.{ .values = &.{}, .tag = 11 });
}

test "source precedes one context evaluation and ordered callback visits" {
    for (samples) |values| {
        for ([_]i64{ -11, -7, -3, 0, 5 }) |tag| try check.execute(.{ .values = values, .tag = tag });
    }
}

test "source failure prevents context and callback evaluation" {
    for (samples) |values| try check.execute(.{ .values = values, .failure = .source });
}

test "context failure propagates before any callback even on empty input" {
    for (samples) |values| try check.execute(.{ .values = values, .failure = .context });
}

test "every reachable callback failure preserves preceding context evaluation" {
    for (samples) |values| {
        for (1..values.len + 2) |boundary| try check.execute(.{ .values = values, .failure = .callback, .fail_at = boundary });
    }
}

test "callback failures follow the actual decision boundary" {
    const values: []const i64 = if (method == .every) &.{ 1, 0, 2, 3 } else &.{ 0, 1, 2, 3 };

    try check.execute(.{ .values = values, .failure = .callback, .fail_at = 3 });
}

test "context is recomputed for each independent execution" {
    for (0..17) |iteration| {
        const tag = @as(i64, @intCast(iteration)) - 11;

        try check.execute(.{ .values = &.{ -3, 0, 7, 13 }, .tag = tag });
    }
}

test "long callback traversal keeps one context and preserves input" {
    var values: [4096]i64 = undefined;

    for (&values, 0..) |*item, index| {
        item.* = if (method == .every) 1 else if (method == .some) 0 else @as(i64, @intCast(index % 23)) - 11;
    }

    try check.execute(.{ .values = &values });
}
