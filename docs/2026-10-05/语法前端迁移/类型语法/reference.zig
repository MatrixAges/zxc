const std = @import("std");
const zx = @import("zx");
const Parser = @import("parser");
const lexer = @import("lexer");
const generated = @import("generated");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    const starts = try std.json.parseFromSlice([]const usize, allocator, args[2], .{});
    const depth = try std.fmt.parseInt(usize, args[3], 10);
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);
    var reporter = zx.Reporter{};
    const lexed = try lexer.lex(allocator, source, &reporter);

    for (starts.value) |start| {
        var arena = std.heap.ArenaAllocator.init(allocator);

        defer arena.deinit();

        reporter = .{};

        var parser = Parser{ .allocator = arena.allocator(), .source = source, .tokens = lexed.tokens, .reporter = &reporter, .index = start, .depth = depth };

        const value = parser.typeNode() catch |err| switch (err) {
            error.InvalidSource => null,
            else => return err,
        };

        const actual = try generated.execute(&arena, &.{ .source = source, .start = start, .depth = depth });
        const diagnostic: struct { code: []const u8, start: usize, end: usize, message: []const u8 } = if (reporter.diagnostic) |item| .{ .code = @tagName(item.code), .start = item.span.start, .end = item.span.end, .message = item.message } else .{ .code = "", .start = @as(usize, 0), .end = @as(usize, 0), .message = "" };

        try std.json.Stringify.value(.{ .start = start, .expected = .{ .value = value, .index = parser.index, .diagnostic = diagnostic }, .actual = actual }, .{}, &output.interface);
        try output.interface.writeByte('\n');
    }

    try output.interface.flush();
}
