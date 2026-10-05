const std = @import("std");
const zx = @import("zx");
const rule = @import("declarations").Declaration;
const Parser = std.meta.Child(@typeInfo(@TypeOf(rule.parse)).@"fn".param_types[0].?);
const lexer = @import("lexer");
const scan = @import("scan");
const generated = @import("generated");
const Diagnostic = struct { code: []const u8 = "", start: usize = 0, end: usize = 0, message: []const u8 = "" };

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const depth = try std.fmt.parseInt(usize, args[2], 10);
    var reporter = zx.Reporter{};
    const lexed = try lexer.lex(allocator, source, &reporter);
    const scanned = try scan.execute(init.arena, source);
    const Token = std.meta.Child(std.meta.Elem(@FieldType(std.meta.Child(generated.Input), "tokens")));
    const tokens = try allocator.alloc(*const Token, scanned.tokens.len);

    for (scanned.tokens, tokens) |token, *output| {
        const value = try allocator.create(Token);
        const span = try allocator.create(std.meta.Child(@FieldType(Token, "span")));

        span.* = .{ .start = token.span.start, .end = token.span.end };

        value.* = .{
            .kind = std.meta.stringToEnum(@FieldType(Token, "kind"), @tagName(token.kind)).?,
            .word = std.meta.stringToEnum(@FieldType(Token, "word"), @tagName(token.word)).?,
            .symbol = std.meta.stringToEnum(@FieldType(Token, "symbol"), @tagName(token.symbol)).?,
            .span = span,
            .line_break = token.line_break,
            .dollar = token.dollar,
        };

        output.* = value;
    }

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    for (tokens, 0..) |token, start| {
        if (start != 0 and token.word != .Export) continue;

        var arena = std.heap.ArenaAllocator.init(init.gpa);

        defer arena.deinit();

        reporter = .{};

        var parser = Parser{ .allocator = arena.allocator(), .source = source, .tokens = lexed.tokens, .reporter = &reporter, .index = start, .depth = depth };
        var declarations: std.ArrayList(zx.ast.Declaration) = .empty;

        while (true) {
            const value = rule.parse(&parser) catch |err| switch (err) {
                error.InvalidSource => break,
                else => return err,
            };

            if (value == .miss) break;
            try declarations.append(arena.allocator(), value.hit);
        }

        const diagnostic: Diagnostic = if (reporter.diagnostic) |issue| .{ .code = @tagName(issue.code), .start = issue.span.start, .end = issue.span.end, .message = issue.message } else .{};
        const actual = try generated.execute(&arena, &.{ .tokens = tokens, .start = start, .depth = depth });

        if (actual.control.phase != .Done) return error.IncompleteDeclarationParse;

        try std.json.Stringify.value(.{
            .start = start,
            .expected = .{ .declarations = declarations.items, .index = parser.index, .diagnostic = diagnostic },
            .actual = .{ .declarations = actual.declarations, .members = actual.members, .types = actual.types.tree, .index = actual.control.index, .diagnostic = if (actual.control.type_diagnostic) actual.types.control.diagnostic else actual.control.diagnostic },
        }, .{}, &output.interface);

        try output.interface.writeByte('\n');
    }

    try output.interface.flush();
}
