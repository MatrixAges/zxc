const std = @import("std");
const zx = @import("zx");
const Parser = @import("frontend").Parser;
const lexer = @import("lexer");
const program = @import("program");
const compare = @import("tree_compare.zig");
const Case = struct { name: []const u8, source: []const u8, start: u64, depth: u64, sha256: []const u8 };

fn check(case: Case) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(case.source, &digest, .{});

    try std.testing.expectEqualStrings(case.sha256, &std.fmt.bytesToHex(digest, .lower));

    var reporter = zx.Reporter{};
    const lexed = try lexer.lex(arena.allocator(), case.source, &reporter);
    var parser = Parser{ .allocator = arena.allocator(), .source = case.source, .tokens = lexed.tokens, .reporter = &reporter, .index = @intCast(case.start), .depth = @intCast(case.depth) };

    const expected = parser.typeNode() catch |err| switch (err) {
        error.InvalidSource => null,
        else => return err,
    };

    const actual = try program.execute(&arena, &.{ .source = case.source, .start = case.start, .depth = case.depth });

    try std.testing.expectEqual(.Done, actual.control.phase);
    try std.testing.expectEqual(parser.index, actual.control.index);

    if (reporter.diagnostic) |diagnostic| {
        try std.testing.expect(expected == null);
        try std.testing.expectEqualStrings(@tagName(diagnostic.code), actual.control.diagnostic.code);
        try std.testing.expectEqualStrings(diagnostic.message, actual.control.diagnostic.message);
        try std.testing.expectEqual(diagnostic.span.start, actual.control.diagnostic.start);
        try std.testing.expectEqual(diagnostic.span.end, actual.control.diagnostic.end);
    } else {
        try std.testing.expectEqualStrings("", actual.control.diagnostic.code);
        try std.testing.expectEqualStrings("", actual.control.diagnostic.message);
        try std.testing.expectEqual(@as(u64, 0), actual.control.diagnostic.start);
        try std.testing.expectEqual(@as(u64, 0), actual.control.diagnostic.end);
        try std.testing.expectEqual(@as(usize, 0), actual.frames.len);
        try compare.same(expected orelse return error.MissingNativeType, actual, actual.control.result);
    }
}

test "generated ZX type grammar matches native tree index and diagnostics" {
    const cases = try std.json.parseFromSlice([]const Case, std.testing.allocator, @embedFile("cases.json"), .{});

    defer cases.deinit();

    try std.testing.expect(cases.value.len != 0);

    for (cases.value) |case| {
        check(case) catch |err| {
            std.debug.print("type case {s}, start {d}, depth {d}: {s}\n", .{ case.name, case.start, case.depth, case.source });

            return err;
        };
    }
}
