const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const Counts = struct { root: usize, interpolations: []const usize };

fn check(source: []const u8, counts: Counts) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const expected = try program.execute(&arena, source);

    try std.testing.expectEqual(counts.root, expected.hints.len);
    try std.testing.expectEqual(counts.root, expected.lexical.lexed.tokens.len);
    try std.testing.expectEqual(counts.root == 0, expected.lexical.lexed.diagnostic.message.len != 0);
    try std.testing.expectEqual(counts.interpolations.len, expected.interpolation_hints.len);
    try std.testing.expectEqual(counts.interpolations.len, expected.lexical.interpolations.len);

    for (counts.interpolations, expected.interpolation_hints, expected.lexical.interpolations) |count, hints, interpolation| {
        try std.testing.expectEqual(count, hints.len);
        try std.testing.expectEqual(count, interpolation.lexed.tokens.len);
        try std.testing.expectEqual(count == 0, interpolation.lexed.diagnostic.message.len != 0);
    }

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ source, expected });
}

fn run(allocator: std.mem.Allocator, source: []const u8, expected: program.Output) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const original = try program.execute(&arena, source);

    const repeated = program.execute(&arena, "x => x") catch |err| {
        try std.testing.expectEqualDeep(expected.*, original.*);

        return err;
    };

    try std.testing.expectEqualStrings("", repeated.lexical.lexed.diagnostic.message);
    try std.testing.expectEqual(@as(usize, 4), repeated.hints.len);
    try std.testing.expect(repeated.hints[0].lambda);
    try std.testing.expectEqualDeep(expected.*, original.*);
}

test "expression preparation retains empty source EOF through allocation failures" {
    try check("", .{ .root = 1, .interpolations = &.{} });
}

test "expression preparation retains nested hint streams through allocation failures" {
    try check("`a${x => x}b${`c${y ?? 1}`}d`", .{ .root = 2, .interpolations = &.{ 4, 4, 2 } });
}

test "expression preparation retains growing root hints through allocation failures" {
    const fragment = "x => x + 1 ; ";
    var source: [fragment.len * 48]u8 = undefined;

    for (0..48) |index| @memcpy(source[index * fragment.len ..][0..fragment.len], fragment);
    try check(&source, .{ .root = 289, .interpolations = &.{} });
}

test "expression preparation retains failed interpolation alongside valid hints" {
    try check("`a${@}b${x => x}c`", .{ .root = 2, .interpolations = &.{ 0, 4 } });
}

test "expression preparation retains root lexical failure through allocation failures" {
    try check("\xff", .{ .root = 0, .interpolations = &.{} });
}
