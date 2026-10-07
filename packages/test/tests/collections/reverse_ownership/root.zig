const std = @import("std");
const program = @import("program");
const model = @import("model.zig");
const allocation_testing = @import("allocation_testing");

fn run(allocator: std.mem.Allocator, input: []const i64) !void {
    const storage = try std.testing.allocator.alloc(i64, input.len + 2);

    defer std.testing.allocator.free(storage);

    storage[0] = -9191;
    storage[storage.len - 1] = 7373;

    @memcpy(storage[1..][0..input.len], input);

    const original = try std.testing.allocator.dupe(i64, storage);

    defer std.testing.allocator.free(original);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const first = try program.execute(&arena, storage[1..][0..input.len]);

    try std.testing.expectEqualSlices(i64, original, storage);
    try model.check(first, input);

    const later_input = [_]i64{ 8, -2, 5, 5 };
    const later = program.execute(&arena, &later_input);

    try std.testing.expectEqualSlices(i64, original, storage);
    try model.check(first, input);
    try model.check(try later, &later_input);
    try model.check(first, input);
}

test "reverse preserves empty and singleton inputs and retained results" {
    for ([_][]const i64{ &.{}, &.{0}, &.{-7}, &.{7} }) |input| try run(std.testing.allocator, input);
}

test "reverse distinguishes source order duplicates and negative values" {
    for ([_][]const i64{ &.{ 1, 2, 3 }, &.{ 3, 1, 2 }, &.{ 0, -1, 7, 7, -3 }, &.{ std.math.minInt(i64), -1, 0, 17 } }) |input| {
        try run(std.testing.allocator, input);
    }
}

test "reverse releases every failed allocation while retaining shared or borrowed values" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{@as([]const i64, &.{ 3, 1, 2 })});
}

test "reverse empty then nonempty calls release every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{@as([]const i64, &.{})});
}

test "reverse preserves exact representable mapped and unmapped integer boundaries" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const boundary = if (comptime model.mapped()) std.math.maxInt(i64) - 1 else std.math.maxInt(i64);
    var input = [_]i64{ 2, boundary, -3 };
    const original = input;
    const result = program.execute(&arena, &input);

    try std.testing.expectEqualSlices(i64, &original, &input);
    try model.check(try result, &input);
}
