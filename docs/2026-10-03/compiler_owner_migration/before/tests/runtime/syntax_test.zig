const std = @import("std");

test "syntax runtime: every numeric comparison and logical operator" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const program = @import("operators");
    const negative = try program.execute(&arena, .{ .left = -7, .right = 3 });

    try std.testing.expectEqual(@as(i64, -4), negative.sum);
    try std.testing.expectEqual(@as(i64, -10), negative.difference);
    try std.testing.expectEqual(@as(i64, -21), negative.product);
    try std.testing.expectEqual(@as(i64, -2), negative.quotient);
    try std.testing.expectEqual(@as(i64, -1), negative.remainder);
    try std.testing.expectEqual(@as(i64, 7), negative.negative);
    try std.testing.expect(!negative.equal and negative.not_equal);
    try std.testing.expect(negative.less and negative.less_equal);
    try std.testing.expect(!negative.greater and !negative.greater_equal);
    try std.testing.expect(negative.and_value and negative.or_value and !negative.not_value);
    try std.testing.expectEqual(@as(i64, -1), negative.precedence);
    try std.testing.expectEqual(@as(i64, -8), negative.grouped);
    try std.testing.expectEqual(@as(i64, -11), negative.associative);

    const equal = try program.execute(&arena, .{ .left = 3, .right = 3 });

    try std.testing.expect(equal.equal and !equal.not_equal);
    try std.testing.expect(!equal.less and equal.less_equal);
    try std.testing.expect(!equal.greater and equal.greater_equal);
    try std.testing.expect(!equal.and_value and !equal.or_value and equal.not_value);

    const greater = try program.execute(&arena, .{ .left = 7, .right = -3 });

    try std.testing.expect(greater.greater and greater.greater_equal);
    try std.testing.expect(!greater.less and !greater.less_equal);
    try std.testing.expect(!greater.and_value and greater.or_value);
    try std.testing.expectEqual(@as(i64, -2), greater.quotient);
    try std.testing.expectEqual(@as(i64, 1), greater.remainder);
}

test "syntax runtime: if else if switch and lexical shadowing" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    for ([_]i64{ -1, 0, 1, 2, 3 }, [_]u64{ 1, 2, 3, 4, 9 }) |input, expected| {
        try std.testing.expectEqual(expected, try @import("control_flow").execute(&arena, input));
    }
}

test "syntax runtime: tuple destructuring shorthand nested lists and omitted optional" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const result = try @import("aggregate_values").execute(&arena, 7);

    try std.testing.expectEqual(@as(u64, 7), result.value);
    try std.testing.expectEqual(@as(u64, 7), result.tuple[0]);
    try std.testing.expect(result.tuple[1]);
    try std.testing.expectEqual(@as(usize, 0), result.nested[0].len);
    try std.testing.expectEqualSlices(u64, &.{ 7, 2 }, result.nested[1]);
    try std.testing.expectEqual(@as(u64, 2), result.length);
    try std.testing.expect(result.missing == null);
}

test "syntax runtime: escapes nested interpolation and string comparisons" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const result = try @import("string_values").execute(&arena, "zx");

    try std.testing.expectEqualStrings("line\n\t\"quoted\"\\end", result.escaped);
    try std.testing.expectEqualStrings("outer-inner-zx", result.nested);
    try std.testing.expectEqual(@as(u64, 2), result.length);
    try std.testing.expect(result.equal and !result.not_equal);

    const empty = try @import("string_values").execute(&arena, "");

    try std.testing.expectEqualStrings("outer-inner-", empty.nested);
    try std.testing.expectEqual(@as(u64, 0), empty.length);
    try std.testing.expect(!empty.equal and empty.not_equal);
}

test "syntax runtime: empty and nonempty collection callbacks" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const empty = try @import("collection_boundaries").execute(&arena, &.{});

    try std.testing.expectEqual(@as(usize, 0), empty.mapped.len);
    try std.testing.expectEqual(@as(usize, 0), empty.filtered.len);
    try std.testing.expectEqual(@as(u64, 10), empty.total);

    const values = try @import("collection_boundaries").execute(&arena, &.{ 1, 2, 3 });

    try std.testing.expectEqualSlices(u64, &.{ 2, 4, 6 }, values.mapped);
    try std.testing.expectEqualSlices(u64, &.{3}, values.filtered);
    try std.testing.expectEqual(@as(u64, 16), values.total);
}

test "syntax runtime: explicit and implicit void return" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try @import("void_return").execute(&arena, true);
    try @import("void_return").execute(&arena, false);
}
