const std = @import("std");
pub const scanner = @import("scanner");

pub const Token = struct {
    text: []const u8,
    kind: []const u8,
    word: []const u8 = "Root",
    symbol: []const u8 = "None",
    dollar: bool = false,
};

pub const tokens = [_]Token{
    .{ .text = "$value", .kind = "Identifier", .word = "Dead", .dollar = true },
    .{ .text = "return", .kind = "Keyword", .word = "Return" },
    .{ .text = "17", .kind = "Number" },
    .{ .text = "\"x\"", .kind = "String" },
    .{ .text = "`a\nb`", .kind = "Template" },
    .{ .text = ")", .kind = "Punctuation", .symbol = "CloseParen" },
};

pub const gaps = [_][]const u8{ " ", "\t", "\x0b", "\x0c", "\n", "\r", "\r\n", "/**/", "/*\n*/", "/*\r*/", "//x\n", "/*a*/ /*b\r\n*/\t" };

pub fn lineBreak(text: []const u8) bool {
    return std.mem.indexOfAny(u8, text, "\r\n") != null;
}

pub fn expectToken(actual: anytype, expected: Token, start: usize, line_break: bool) !void {
    try std.testing.expectEqualStrings(expected.kind, @tagName(actual.kind));
    try std.testing.expectEqualStrings(expected.word, @tagName(actual.word));
    try std.testing.expectEqualStrings(expected.symbol, @tagName(actual.symbol));
    try std.testing.expectEqual(expected.dollar, actual.dollar);
    try std.testing.expectEqual(line_break, actual.line_break);
    try std.testing.expectEqual(start, actual.span.start);
    try std.testing.expectEqual(start + expected.text.len, actual.span.end);
}
