const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const Counts = struct { templates: usize, parts: usize, interpolations: usize };

fn check(source: []const u8, counts: ?Counts, message: []const u8) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const expected = try program.execute(&arena, source);

    try std.testing.expectEqualStrings(message, expected.lexed.diagnostic.message);
    try std.testing.expectEqual(expected.lexed.tokens.len, expected.token_templates.len);

    if (counts) |value| {
        try std.testing.expectEqual(value.templates, expected.templates.len);
        try std.testing.expectEqual(value.parts, expected.parts.len);
        try std.testing.expectEqual(value.interpolations, expected.interpolations.len);
    }

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{ source, expected });
}

fn run(allocator: std.mem.Allocator, source: []const u8, expected: program.Output) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const original = try program.execute(&arena, source);
    const repeated = try program.execute(&arena, "`next${3}`");

    try std.testing.expectEqualStrings("", repeated.lexed.diagnostic.message);
    try std.testing.expectEqual(@as(usize, 1), repeated.templates.len);
    try std.testing.expectEqual(@as(usize, 1), repeated.interpolations.len);
    try std.testing.expectEqualDeep(expected.*, original.*);
}

test "template preparation retains plain lexical results through allocation failures" {
    try check("name /* comment */ + 42\n", .{ .templates = 0, .parts = 0, .interpolations = 0 }, "");
}

test "template preparation retains nested interpolation results through allocation failures" {
    try check("head ; `a${1}b${`c${2}d`}e` tail", .{ .templates = 2, .parts = 8, .interpolations = 3 }, "");
}

test "template preparation retains growing sibling interpolation results through allocation failures" {
    const fragment = "a${1}";
    var source: [fragment.len * 40 + 3]u8 = undefined;
    source[0] = '`';

    for (0..40) |index| @memcpy(source[1 + index * fragment.len ..][0..fragment.len], fragment);

    @memcpy(source[source.len - 2 ..], "z`");

    try check(&source, .{ .templates = 1, .parts = 81, .interpolations = 40 }, "");
}

test "template preparation retains partial failure results through allocation failures" {
    try check("`ok${1}` ; `bad${/*", null, "unterminated comment in template");
}
