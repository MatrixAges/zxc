const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const Input = std.meta.Child(program.Input);
const State = std.meta.Child(@FieldType(Input, "seed"));
const initial: State = .{ .count = 3, .total = 10, .last = 2, .flag = true, .optional = null };
const rows = [_][]const u64{ &.{2}, &.{3}, &.{5} };

fn check(gpa: std.mem.Allocator, failed_index: ?usize) !void {
    var seed = initial;
    var steps = rows;

    if (failed_index) |index| steps[index] = &.{};

    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .seed = &seed, .steps = &steps });

    try std.testing.expectEqualDeep(initial, seed);

    for (steps, 0..) |row, index| {
        const expected: []const u64 = if (failed_index == index) &.{} else rows[index];

        try std.testing.expectEqualSlices(u64, expected, row);
    }

    const result = executed catch |err| blk: {
        if (err == error.OutOfMemory) return err;

        try std.testing.expect(failed_index != null);
        try std.testing.expectEqual(error.IndexOutOfBounds, err);

        break :blk null;
    };

    try std.testing.expectEqual(failed_index != null, result == null);

    const recovered = try program.execute(&arena, &.{ .seed = &seed, .steps = &rows });
    const expected: State = .{ .count = 6, .total = 32, .last = 5, .flag = false, .optional = 3 };

    try std.testing.expectEqualDeep(expected, recovered.*);
    try std.testing.expectEqualDeep(initial, seed);
    if (result) |value| try std.testing.expectEqualDeep(expected, value.*);
}

test "flat value call propagates first middle and last index failure and recovers" {
    for (0..rows.len) |index| try check(std.testing.allocator, index);
}

test "flat value call valid rows preserve arithmetic and repeated execution" {
    try check(std.testing.allocator, null);
}

test "flat value call empty reduction does not invoke a fallible helper" {
    var seed = initial;
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const result = try program.execute(&arena, &.{ .seed = &seed, .steps = &.{} });

    try std.testing.expect(result == &seed);
    try std.testing.expectEqualDeep(initial, result.*);
}

test "flat value call failed execution and recovery release every allocation" {
    for (0..rows.len) |index| try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{@as(?usize, index)});
}
