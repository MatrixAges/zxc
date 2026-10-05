const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");

fn check(source: []const u8, depth: u64, message: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const expected = try program.execute(&arena, &.{ .source = source, .start = 0, .depth = depth });

    try std.testing.expectEqualStrings(message, expected.control.diagnostic.message);
    try std.testing.expectEqual(.Done, expected.control.phase);

    if (message.len == 0) {
        try std.testing.expectEqual(@as(usize, 0), expected.frames.len);
        try std.testing.expectEqual(.Object, expected.tree.nodes[expected.control.result].kind);
        try std.testing.expectEqual(@as(u64, 2), expected.tree.nodes[expected.control.result].count);
    }

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ source, depth, expected });
}

fn run(allocator: std.mem.Allocator, source: []const u8, depth: u64, expected: program.Output) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const original = try program.execute(&arena, &.{ .source = source, .start = 0, .depth = depth });
    const repeated = try program.execute(&arena, &.{ .source = "bool ; tail", .start = 0, .depth = 0 });

    try std.testing.expectEqualStrings("", repeated.control.diagnostic.message);
    try std.testing.expectEqual(.Done, repeated.control.phase);
    try std.testing.expectEqual(@as(u64, 1), repeated.control.index);
    try std.testing.expectEqual(.Named, repeated.tree.nodes[repeated.control.result].kind);
    try std.testing.expectEqualDeep(expected.*, original.*);
}

test "generated type parser retains nested trees and cleans every allocation failure" {
    try check("{one: [u64?, Box<bool>], two: {leaf: string[]}} ; tail", 0, "");
}

test "generated type parser retains syntax diagnostics and cleans every allocation failure" {
    try check("Box<[u64, bool]", 0, "expected >");
}

test "generated type parser retains depth diagnostics and cleans every allocation failure" {
    try check("u64", 256, "syntax nesting exceeds 256 levels");
}
