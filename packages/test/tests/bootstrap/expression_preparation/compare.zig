const std = @import("std");
const zx = @import("zx");
const lexer = @import("lexer");
const program = @import("program");

pub fn check(source: []const u8, interpolation_count: ?usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const actual = try program.execute(&arena, source);

    try hints(arena.allocator(), source, actual.hints);
    try std.testing.expectEqual(actual.lexical.interpolations.len, actual.interpolation_hints.len);
    if (interpolation_count) |count| try std.testing.expectEqual(count, actual.interpolation_hints.len);

    for (actual.lexical.interpolations, actual.interpolation_hints) |interpolation, values| {
        try hints(arena.allocator(), source[interpolation.span.start..interpolation.span.end], values);
    }
}

fn hints(allocator: std.mem.Allocator, source: []const u8, actual: anytype) !void {
    var reporter = zx.Reporter{};

    const lexed = lexer.lex(allocator, source, &reporter) catch |err| switch (err) {
        error.InvalidSource => {
            try std.testing.expectEqual(@as(usize, 0), actual.len);

            return;
        },
        else => return err,
    };

    try std.testing.expectEqual(lexed.tokens.len, actual.len);

    for (lexed.tokens, actual, 0..) |token, got, index| {
        const text = token.text(source);

        const generic = for ([_][]const u8{ "queryOne", "queryMany", "insert", "update", "delete", "transaction" }) |name| {
            if (std.mem.eql(u8, text, name)) break true;
        } else false;

        try std.testing.expectEqual(lambda(source, lexed.tokens[index..]), got.lambda);
        try std.testing.expectEqual(generic, got.generic);

        if (zx.syntax.Operator.parse(text)) |operator| {
            const name = switch (operator) {
                .coalesce => "Coalesce",
                .add => "Add",
                .subtract => "Subtract",
                .multiply => "Multiply",
                .divide => "Divide",
                .remainder => "Remainder",
                .equal => "Equal",
                .not_equal => "NotEqual",
                .less => "Less",
                .less_equal => "LessEqual",
                .greater => "Greater",
                .greater_equal => "GreaterEqual",
                .logical_and => "And",
                .logical_or => "Or",
            };

            const family = switch (operator) {
                .coalesce => "Coalesce",
                .logical_and, .logical_or => "Logical",
                else => "None",
            };

            try std.testing.expectEqualStrings(name, @tagName(got.binary.operator));
            try std.testing.expectEqual(operator.precedence(), got.binary.precedence);
            try std.testing.expectEqualStrings(family, @tagName(got.binary.family));
        } else {
            try std.testing.expectEqual(.None, got.binary.operator);
            try std.testing.expectEqual(@as(u8, 0), got.binary.precedence);
            try std.testing.expectEqual(.None, got.binary.family);
        }
    }
}

fn lambda(source: []const u8, tokens: []const zx.syntax.Token) bool {
    if (tokens.len < 2) return false;
    if (tokens[0].kind == .identifier) return std.mem.eql(u8, tokens[1].text(source), "=>");
    if (!std.mem.eql(u8, tokens[0].text(source), "(")) return false;

    var cursor: usize = 1;

    while (cursor < tokens.len and !std.mem.eql(u8, tokens[cursor].text(source), ")")) {
        if (tokens[cursor].kind != .identifier) return false;

        cursor += 1;

        if (cursor < tokens.len and std.mem.eql(u8, tokens[cursor].text(source), ",")) {
            cursor += 1;
        } else if (cursor >= tokens.len or !std.mem.eql(u8, tokens[cursor].text(source), ")")) return false;
    }

    return cursor + 1 < tokens.len and std.mem.eql(u8, tokens[cursor + 1].text(source), "=>");
}
