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

    const offset = if (args.len > 2) try std.fmt.parseInt(usize, args[2], 10) else body.span.start;
    const depth = if (args.len > 3) try std.fmt.parseInt(usize, args[3], 10) else 0;
    const state_block = args.len > 4 and std.mem.eql(u8, args[4], "state");

    const start = for (lexed.tokens, 0..) |token, index| {
        if (token.span.start == offset) break index;
    } else return error.BodyTokenMissing;

    const actual = try generated.execute(init.arena, &.{ .source = source, .start = start, .depth = depth, .state_block = state_block });

    if (actual.control.phase != .Done) return error.IncompleteBodyParse;

    const actual_payload = .{
        .tree = actual.tree,
        .result = actual.control.result,
        .expressions = actual.expression.tree,
        .types = actual.expression.types.tree,
        .index = actual.expression.control.index,
        .last_end = actual.expression.control.last_end,
        .diagnostic = actual.control.diagnostic,
        .expression_diagnostic = actual.control.expression_diagnostic,
        .value_diagnostic = actual.expression.control.diagnostic,
        .type_diagnostic = actual.expression.types.control.diagnostic,
    };

    parser.index = start;
    parser.depth = depth;
    parser.state_block_depth = if (state_block) 1 else 0;

    const expected = parser.block() catch |err| switch (err) {
        error.InvalidSource => {
            const issue = reporter.diagnostic.?;

            try std.json.Stringify.value(.{ .expected_error = .{ .code = @tagName(issue.code), .span = issue.span, .message = issue.message }, .actual = actual_payload }, .{}, &output.interface);
            try output.interface.flush();

            return;
        },
        else => return err,
    };

    try std.json.Stringify.value(.{
        .expected = .{ .body = expected, .index = parser.index, .last_end = lexed.tokens[parser.index - 1].span.end },
        .actual = actual_payload,
    }, .{}, &output.interface);

    try output.interface.flush();
}
