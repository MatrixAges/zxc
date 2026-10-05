const std = @import("std");
const zx = @import("zx");
const lexer = @import("lexer");

pub fn same(allocator: std.mem.Allocator, source: []const u8, start: usize, end: usize, actual: anytype) !void {
    var reporter = zx.Reporter{};

    const expected = lexer.lex(allocator, source[start..end], &reporter) catch |err| switch (err) {
        error.InvalidSource => {
            const diagnostic = reporter.diagnostic orelse return error.MissingDiagnostic;

            try std.testing.expectEqualStrings(@tagName(diagnostic.code), actual.diagnostic.code);
            try std.testing.expectEqualStrings(diagnostic.message, actual.diagnostic.message);
            try std.testing.expectEqual(start + diagnostic.span.start, actual.diagnostic.start);
            try std.testing.expectEqual(start + diagnostic.span.end, actual.diagnostic.end);

            return;
        },
        else => return err,
    };

    try std.testing.expectEqualStrings("", actual.diagnostic.code);
    try std.testing.expectEqualStrings("", actual.diagnostic.message);
    try std.testing.expectEqual(@as(u64, 0), actual.diagnostic.start);
    try std.testing.expectEqual(@as(u64, 0), actual.diagnostic.end);
    try std.testing.expectEqual(expected.tokens.len, actual.tokens.len);
    try std.testing.expectEqual(expected.comments.len, actual.comments.len);

    for (expected.tokens, actual.tokens, 0..) |token, got, index| {
        try std.testing.expect(std.ascii.eqlIgnoreCase(@tagName(token.kind), @tagName(got.kind)));
        try std.testing.expectEqual(start + token.span.start, got.span.start);
        try std.testing.expectEqual(start + token.span.end, got.span.end);

        const previous = if (index == 0) token.span.start else expected.tokens[index - 1].span.end;
        const line_break = index != 0 and std.mem.indexOfAny(u8, source[start + previous .. start + token.span.start], "\r\n") != null;

        try std.testing.expectEqual(line_break, got.line_break);
        try std.testing.expectEqual(token.kind == .identifier and token.span.start < token.span.end and source[start + token.span.start] == '$', got.dollar);
    }

    for (expected.comments, actual.comments) |comment, got| {
        try std.testing.expectEqual(start + comment.start, got.start);
        try std.testing.expectEqual(start + comment.end, got.end);
    }
}
