const std = @import("std");
const collections = @import("collections");
const transforms = @import("transforms");
const optional = @import("optional");
const enums = @import("enums");
const spread = @import("spread");
const indexed = @import("index");

test "runtime: explicit ownership operations preserve caller input" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input = [_]u64{ 2, 8, 1 };
    const result = try collections.execute(&arena, &input);

    try std.testing.expectEqualSlices(u64, &.{ 8, 2, 1 }, result.values);
    try std.testing.expectEqual(@as(?u64, 7), result.removed);
    try std.testing.expectEqualSlices(u64, &.{ 2, 8, 1 }, &input);
}

test "runtime: nested callbacks use distinct parameters" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const result = try transforms.execute(&arena, &.{ &.{ 1, 3, 5 }, &.{ 2, 4 }, &.{} });

    try std.testing.expectEqualSlices(u64, &.{ 8, 4, 0 }, result);
}

test "runtime: optional fallback template interpolation and string equality" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const absent = try optional.execute(&arena, &.{ .value = null, .name = "zx" });

    try std.testing.expectEqual(@as(u64, 12), absent.amount);
    try std.testing.expectEqualStrings("hello zx: 12", absent.label);
    try std.testing.expect(absent.matched);

    const present = try optional.execute(&arena, &.{ .value = 0, .name = "zig" });

    try std.testing.expectEqual(@as(u64, 0), present.amount);
    try std.testing.expectEqualStrings("hello zig: 0", present.label);
    try std.testing.expect(!present.matched);
}

test "runtime: exhaustive enum switch returns from either branch" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(@as(i64, -2), try enums.execute(&arena, &.{ .mode = .Add, .value = -3 }));
    try std.testing.expectEqual(@as(i64, -4), try enums.execute(&arena, &.{ .mode = .Subtract, .value = -3 }));
}

test "runtime: later explicit field replaces spread field" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const input: spread.Input = &.{ .left = 5, .right = 8 };
    const result = try spread.execute(&arena, input);

    try std.testing.expectEqual(@as(u64, 8), result.left);
    try std.testing.expectEqual(@as(u64, 8), result.right);
    try std.testing.expectEqual(@as(u64, 5), input.left);
}

test "runtime: list bounds fail consistently" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(@as(u64, 9), try indexed.execute(&arena, &.{ .items = &.{9}, .index = 0 }));
    try std.testing.expectError(error.IndexOutOfBounds, indexed.execute(&arena, &.{ .items = &.{9}, .index = 1 }));
    try std.testing.expectError(error.IndexOutOfBounds, indexed.execute(&arena, &.{ .items = &.{}, .index = std.math.maxInt(u64) }));
}

test "runtime: multi-file imports and pure callbacks execute together" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const result = try @import("modules").execute(&arena, &.{ 1, 5 });

    try std.testing.expectEqualSlices(u64, &.{ 4, 8 }, result);
}

test "runtime: explicitly registered native function executes" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(@as(f64, 3), try @import("external").execute(&arena, 9));
    try std.testing.expectEqual(@as(f64, 4), try @import("external").execute(&arena, 100));
    try std.testing.expectEqual(@as(f64, 1), try @import("external").execute(&arena, 0));
}

test "runtime: splice concat and empty pop preserve tuple results" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const result = try @import("splice").execute(&arena, &.{ 1, 2, 3, 4 });

    try std.testing.expectEqualSlices(u64, &.{ 1, 7, 8, 4, 9 }, result.values);
    try std.testing.expectEqualSlices(u64, &.{ 2, 3 }, result.removed);
    try std.testing.expectEqual(@as(?u64, null), result.empty);
    try std.testing.expectError(error.IndexOutOfBounds, @import("splice").execute(&arena, &.{1}));
}

fn executeAllocationFailures(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const result = try optional.execute(&arena, &.{ .value = 2, .name = "memory" });

    try std.testing.expectEqualStrings("hello memory: 2", result.label);

    const values = try collections.execute(&arena, &.{ 1, 2, 3 });

    try std.testing.expectEqualSlices(u64, &.{ 3, 2, 1 }, values.values);
}

test "runtime: allocation failure releases the entire call arena" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, executeAllocationFailures, .{});
}

test "runtime: signed division truncates toward zero and remainder follows dividend" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const result = try @import("arithmetic").execute(&arena, &.{ .left = -7, .right = 3 });

    try std.testing.expectEqual(@as(i64, -4), result.sum);
    try std.testing.expectEqual(@as(i64, -10), result.difference);
    try std.testing.expectEqual(@as(i64, -21), result.product);
    try std.testing.expectEqual(@as(i64, -2), result.quotient);
    try std.testing.expectEqual(@as(i64, -1), result.remainder);
    try std.testing.expect(std.math.signbit(result.negative_zero));
}

test "runtime: boolean conditional and optional operators preserve short circuit" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const skipped = try @import("short_circuit").execute(&arena, &.{ .flag = false, .value = 6, .divisor = 0, .optional = 7, .items = &.{} });

    try std.testing.expect(!skipped.and_value);
    try std.testing.expect(skipped.or_value);
    try std.testing.expectEqual(@as(u64, 0), skipped.selected);
    try std.testing.expectEqual(@as(u64, 7), skipped.fallback);

    const evaluated = try @import("short_circuit").execute(&arena, &.{ .flag = true, .value = 6, .divisor = 2, .optional = null, .items = &.{9} });

    try std.testing.expect(evaluated.and_value);
    try std.testing.expect(evaluated.or_value);
    try std.testing.expectEqual(@as(u64, 3), evaluated.selected);
    try std.testing.expectEqual(@as(u64, 9), evaluated.fallback);
}

test {
    _ = @import("syntax_test.zig");
    _ = @import("boundaries_test.zig");
    _ = @import("numeric_test.zig");
}
