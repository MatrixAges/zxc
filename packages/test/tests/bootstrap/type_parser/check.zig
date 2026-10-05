const std = @import("std");
const zx = @import("zx");
const Parser = @import("frontend").Parser;
const lexer = @import("lexer");
const program = @import("program");
const compare = @import("tree_compare.zig");

pub fn check(source: []const u8, start: u64, depth: u64) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter = zx.Reporter{};

    const lexed = lexer.lex(arena.allocator(), source, &reporter) catch |err| switch (err) {
        error.InvalidSource => {
            const actual = try program.execute(&arena, &.{ .source = source, .start = start, .depth = depth });

            try std.testing.expectEqual(.Done, actual.control.phase);
            try std.testing.expectEqual(@as(usize, 0), actual.tree.nodes.len);
            try std.testing.expectEqual(@as(usize, 0), actual.frames.len);
            try sameDiagnostic(reporter.diagnostic orelse return error.MissingLexicalDiagnostic, actual.control.diagnostic);

            return;
        },
        else => return err,
    };

    var parser = Parser{ .allocator = arena.allocator(), .source = source, .tokens = lexed.tokens, .reporter = &reporter, .index = @intCast(start), .depth = @intCast(depth) };

    const expected = parser.typeNode() catch |err| switch (err) {
        error.InvalidSource => null,
        else => return err,
    };

    const actual = try program.execute(&arena, &.{ .source = source, .start = start, .depth = depth });

    try std.testing.expectEqual(.Done, actual.control.phase);
    try std.testing.expectEqual(parser.index, actual.control.index);

    if (reporter.diagnostic) |diagnostic| {
        try std.testing.expect(expected == null);
        try sameDiagnostic(diagnostic, actual.control.diagnostic);
    } else {
        try std.testing.expectEqualStrings("", actual.control.diagnostic.code);
        try std.testing.expectEqualStrings("", actual.control.diagnostic.message);
        try std.testing.expectEqual(@as(u64, 0), actual.control.diagnostic.start);
        try std.testing.expectEqual(@as(u64, 0), actual.control.diagnostic.end);
        try std.testing.expectEqual(@as(usize, 0), actual.frames.len);
        try compare.same(expected orelse return error.MissingNativeType, actual, actual.control.result);
    }
}

fn sameDiagnostic(expected: zx.Diagnostic, actual: anytype) !void {
    try std.testing.expectEqualStrings(@tagName(expected.code), actual.code);
    try std.testing.expectEqualStrings(expected.message, actual.message);
    try std.testing.expectEqual(expected.span.start, actual.start);
    try std.testing.expectEqual(expected.span.end, actual.end);
}
