const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser");
const lexer = @import("lexer");
const generated = @import("generated");
const adapter = @import("adapter");
const Diagnostic = struct { code: []const u8 = "", start: usize = 0, end: usize = 0, message: []const u8 = "" };

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    var reporter = zx.Reporter{};

    const expected = parse(allocator, source, &reporter) catch |err| switch (err) {
        error.InvalidSource => null,
        else => return err,
    };

    const actual = try generated.execute(init.arena, source);
    const converted: ?zx.ast.Program = if (actual.diagnostic.message.len == 0) try adapter.convert(allocator, source, actual) else null;
    const expected_issue: Diagnostic = if (reporter.diagnostic) |issue| .{ .code = @tagName(issue.code), .start = issue.span.start, .end = issue.span.end, .message = issue.message } else .{};
    const actual_issue = actual.diagnostic;
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .expected = .{ .ast = expected, .diagnostic = expected_issue }, .actual = .{ .ast = converted, .diagnostic = actual_issue } }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}

fn parse(allocator: std.mem.Allocator, source: []const u8, reporter: *zx.Reporter) zx.Error!zx.ast.Program {
    const lexed = try lexer.lex(allocator, source, reporter);
    var parser = Parser{ .allocator = allocator, .source = source, .tokens = lexed.tokens, .reporter = reporter };

    return parser.program();
}
