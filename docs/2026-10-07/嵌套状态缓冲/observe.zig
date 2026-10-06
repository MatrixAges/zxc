const std = @import("std");
const compiler = @import("compiler");
const genz = @import("genz");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    var library = try compiler.library.codec.decode(allocator, bytes);

    defer library.deinit();

    const program = try genz.zx.prepare(allocator, library.program);
    const facts = try genz.zx.value_call.analysis.analyze(allocator, program);
    const summaries = try genz.zx.buffer_call.analysis.functions(allocator, program, facts.values, facts.pure);
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    for (program.functions, summaries, 0..) |function, lanes, index| {
        try std.json.Stringify.value(.{ .index = index, .file = function.file_name, .value = facts.values[index], .pure = facts.pure[index], .local = facts.local[index], .lanes = lanes }, .{}, &output.interface);
        try output.interface.writeByte('\n');
    }

    try output.interface.flush();
}
