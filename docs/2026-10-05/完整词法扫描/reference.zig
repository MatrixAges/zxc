const std = @import("std");
const zx = @import("zx");
const lexer = @import("lexer");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(16 * 1024 * 1024));
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);
    var reporter = zx.Reporter{};

    const result = lexer.lex(allocator, source, &reporter) catch |err| {
        const diagnostic = reporter.diagnostic orelse return err;

        try std.json.Stringify.value(.{
            .tokens = &[_]zx.syntax.Token{},
            .comments = &[_]zx.Span{},
            .diagnostic = .{ .code = @tagName(diagnostic.code), .start = diagnostic.span.start, .end = diagnostic.span.end, .message = diagnostic.message },
        }, .{}, &output.interface);

        try output.interface.writeByte('\n');
        try output.interface.flush();

        return;
    };

    try std.json.Stringify.value(.{
        .tokens = result.tokens,
        .comments = result.comments,
        .diagnostic = .{ .code = "", .start = @as(usize, 0), .end = @as(usize, 0), .message = "" },
    }, .{}, &output.interface);

    try output.interface.writeByte('\n');
    try output.interface.flush();
}
