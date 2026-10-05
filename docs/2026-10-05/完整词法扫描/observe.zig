const std = @import("std");
const lexer = @import("lexer");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    for (args[1..]) |path| {
        const source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, init.gpa, .limited(16 * 1024 * 1024));

        defer init.gpa.free(source);

        var arena = std.heap.ArenaAllocator.init(init.gpa);

        defer arena.deinit();

        const result = try lexer.execute(&arena, source);

        try std.json.Stringify.value(.{ .path = path, .source_bytes = source.len, .tokens = result.tokens.len, .comments = result.comments.len, .arena_capacity = arena.queryCapacity(), .diagnostic = result.diagnostic }, .{}, &output.interface);
        try output.interface.writeByte('\n');
    }

    try output.interface.flush();
}
