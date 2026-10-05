const std = @import("std");
const zx = @import("zx");
const rule = @import("imports").Import;
const Parser = std.meta.Child(@typeInfo(@TypeOf(rule.parse)).@"fn".param_types[0].?);
const lexer = @import("lexer");
const generated = @import("generated");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);
    var reporter = zx.Reporter{};
    const lexed = try lexer.lex(allocator, source, &reporter);
    var parser = Parser{ .allocator = allocator, .source = source, .tokens = lexed.tokens, .reporter = &reporter };

    const program = parser.program() catch |err| switch (err) {
        error.InvalidSource => {
            const issue = reporter.diagnostic.?;

            try std.json.Stringify.value(.{ .skipped = "invalid program", .diagnostic = .{ .code = @tagName(issue.code), .span = issue.span, .message = issue.message } }, .{}, &output.interface);
            try output.interface.flush();

            return;
        },
        else => return err,
    };

    const body = program.body orelse {
        try output.interface.writeAll("{\"skipped\":\"type-only file\"}");
        try output.interface.flush();

        return;
    };

    const start = for (lexed.tokens, 0..) |token, index| {
        if (token.span.start >= program.function_start and std.mem.eql(u8, token.text(source), "function")) break index + 1;
    } else return error.FunctionTokenMissing;

    const end = for (lexed.tokens, 0..) |token, index| {
        if (token.span.start == body.span.start) break index;
    } else return error.BodyTokenMissing;

    const actual = try generated.execute(init.arena, &.{ .source = source, .start = start, .depth = 0 });

    if (actual.control.phase != .Done) return error.IncompleteHeaderParse;

    try std.json.Stringify.value(.{
        .start = start,
        .expected = .{
            .consumes_input = program.consumes_input,
            .has_store = program.has_store,
            .contracts = program.contracts,
            .index = end,
            .last_end = lexed.tokens[end - 1].span.end,
        },
        .actual = .{
            .consumes_input = actual.control.consumes_input,
            .has_store = actual.control.has_store,
            .contracts = actual.contracts,
            .tree = actual.expression.tree,
            .body = actual.body,
            .types = actual.expression.types.tree,
            .index = actual.expression.control.index,
            .last_end = actual.expression.control.last_end,
            .diagnostic = actual.control.diagnostic,
            .expression_diagnostic = actual.control.expression_diagnostic,
            .predicate_diagnostic = actual.expression.control.diagnostic,
        },
    }, .{}, &output.interface);

    try output.interface.flush();
}
