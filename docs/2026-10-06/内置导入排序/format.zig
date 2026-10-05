const std = @import("std");
const zx = @import("zx");
const lexer = @import("lexer");
const Parser = @import("parser");
const lint = @import("lint");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    for (args[1..]) |path| {
        var arena = std.heap.ArenaAllocator.init(init.gpa);

        defer arena.deinit();

        const allocator = arena.allocator();
        const source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, allocator, .unlimited);
        var reporter = zx.Reporter{};
        const lexed = try lexer.lex(allocator, source, &reporter);
        var parser = Parser{ .allocator = allocator, .source = source, .tokens = lexed.tokens, .reporter = &reporter };
        const program = try parser.program();
        const output = try lint.source.format(allocator, .{ .source = source, .comments = lexed.comments, .program = program });

        if (!std.mem.eql(u8, source, output)) try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = output });
    }
}
