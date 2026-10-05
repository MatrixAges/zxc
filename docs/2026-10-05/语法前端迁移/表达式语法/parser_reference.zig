const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser");
const lexer = @import("lexer");
const generated = @import("generated");
const Diagnostic = struct { code: []const u8 = "", start: usize = 0, end: usize = 0, message: []const u8 = "" };

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const starts = try std.json.parseFromSlice([]const usize, allocator, args[2], .{});
    const depth = try std.fmt.parseInt(usize, args[3], 10);
    const minimum = try std.fmt.parseInt(u8, args[4], 10);
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);
    var reporter = zx.Reporter{};

    const lexed: ?zx.syntax.Lexed = lexer.lex(allocator, source, &reporter) catch |err| switch (err) {
        error.InvalidSource => null,
        else => return err,
    };

    const lexical = reporter.diagnostic;

    for (starts.value) |start| {
        var arena = std.heap.ArenaAllocator.init(init.gpa);

        defer arena.deinit();

        reporter = .{};

        var parser = Parser{ .allocator = arena.allocator(), .source = source, .tokens = if (lexed) |value| value.tokens else &.{}, .reporter = &reporter, .index = start, .depth = depth };

        const expected = if (lexed != null) parser.expression(minimum) catch |err| switch (err) {
            error.InvalidSource => null,
            else => return err,
        } else null;

        const issue = reporter.diagnostic orelse lexical;
        const diagnostic: Diagnostic = if (issue) |value| .{ .code = @tagName(value.code), .start = value.span.start, .end = value.span.end, .message = value.message } else .{};
        const actual = try generated.execute(&arena, &.{ .source = source, .start = start, .depth = depth, .minimum = minimum, .allow_lambda = true });

        if (actual.control.phase != .Done) return error.ExpressionDriverBudgetExhausted;

        const actual_issue = if (actual.control.lexical_diagnostic != 0) (if (actual.control.lexical_diagnostic == 1) actual.prepared.lexical.lexed.diagnostic else actual.prepared.lexical.interpolations[actual.control.lexical_diagnostic - 2].lexed.diagnostic) else if (actual.control.type_diagnostic) actual.types.control.diagnostic else actual.control.diagnostic;
        try std.json.Stringify.value(.{ .start = start, .expected = .{ .value = expected, .index = parser.index, .diagnostic = diagnostic }, .actual = .{ .tree = actual.tree, .body = actual.body, .types = actual.types.tree, .result = actual.control.result, .index = actual.control.root_index, .diagnostic = actual_issue } }, .{}, &output.interface);
        try output.interface.writeByte('\n');
    }

    try output.interface.flush();
}
