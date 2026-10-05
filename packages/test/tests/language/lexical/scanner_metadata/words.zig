const std = @import("std");
const f = @import("fixture.zig");

pub const reserved = [_][]const u8{ "export", "type", "default", "function", "const", "if", "else", "return", "true", "false", "import", "enum", "switch", "null", "let", "var", "for", "while", "new", "throw", "async", "await", "case", "break", "match" };
pub const contextual = [_][]const u8{ "in", "owned", "Input", "Output", "from", "store", "requires", "ensures", "_", "queryOne", "queryMany", "insert", "update", "delete", "transaction" };
pub const all = reserved ++ contextual;

pub fn expected(allocator: std.mem.Allocator, text: []const u8) !f.Token {
    var token = f.Token{ .text = text, .kind = "Identifier", .word = "Dead", .dollar = text[0] == '$' };

    for (reserved) |word| {
        if (std.mem.eql(u8, text, word)) token.kind = "Keyword";
    }

    for (all) |word| {
        if (!std.mem.startsWith(u8, word, text)) continue;

        token.word = if (text[0] == '_') "Underscore" else if (std.ascii.isUpper(text[0])) try std.fmt.allocPrint(allocator, "Upper{s}", .{text}) else try std.fmt.allocPrint(allocator, "{c}{s}", .{ std.ascii.toUpper(text[0]), text[1..] });

        break;
    }

    return token;
}
