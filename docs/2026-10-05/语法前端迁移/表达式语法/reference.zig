const std = @import("std");
const zx = @import("zx");
const lexer = @import("lexer");
const generated = @import("generated");
const Binary = struct { operator: []const u8, precedence: u8, family: []const u8 };
const Hint = struct { lambda: bool, generic: bool, binary: Binary };

fn isLambda(source: []const u8, tokens: []const zx.syntax.Token, start: usize) bool {
    var index = start;
    const parenthesized = std.mem.eql(u8, tokens[index].text(source), "(");

    if (parenthesized) index += 1;

    while (index < tokens.len) {
        if (parenthesized and std.mem.eql(u8, tokens[index].text(source), ")")) {
            index += 1;

            break;
        }

        if (tokens[index].kind != .identifier) return false;

        index += 1;

        if (!parenthesized) break;
        if (index >= tokens.len) return false;

        const text = tokens[index].text(source);

        if (std.mem.eql(u8, text, ",")) index += 1 else if (!std.mem.eql(u8, text, ")")) return false;
    }

    return index < tokens.len and std.mem.eql(u8, tokens[index].text(source), "=>");
}

fn hints(allocator: std.mem.Allocator, source: []const u8) ![]const Hint {
    var reporter = zx.Reporter{};

    const lexed = lexer.lex(allocator, source, &reporter) catch |err| switch (err) {
        error.InvalidSource => return &.{},
        else => return err,
    };

    const result = try allocator.alloc(Hint, lexed.tokens.len);

    for (lexed.tokens, result, 0..) |token, *item, index| {
        const text = token.text(source);
        const operator = zx.syntax.Operator.parse(text);

        const generic = for ([_][]const u8{ "queryOne", "queryMany", "insert", "update", "delete", "transaction" }) |method| {
            if (std.mem.eql(u8, text, method)) break true;
        } else false;

        item.* = .{ .lambda = isLambda(source, lexed.tokens, index), .generic = generic, .binary = if (operator) |value| .{
            .operator = switch (value) {
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
            },
            .precedence = value.precedence(),
            .family = switch (value) {
                .coalesce => "Coalesce",
                .logical_and, .logical_or => "Logical",
                else => "None",
            },
        } else .{ .operator = "None", .precedence = 0, .family = "None" } };
    }

    return result;
}

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const actual = try generated.execute(init.arena, source);
    const root = try hints(allocator, source);
    var interpolations: std.ArrayList([]const Hint) = .empty;

    for (actual.lexical.interpolations) |item| {
        try interpolations.append(allocator, try hints(allocator, source[@intCast(item.span.start)..@intCast(item.span.end)]));
    }

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .expected = .{ .hints = root, .interpolation_hints = interpolations.items }, .actual = .{ .hints = actual.hints, .interpolation_hints = actual.interpolation_hints } }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}
