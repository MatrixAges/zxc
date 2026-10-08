const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const memory = init.arena.allocator();
    const args = try init.minimal.args.toSlice(memory);

    if (args.len != 3) return error.ExpectedSourceAndOutputPaths;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], memory, .limited(1024 * 1024));
    const result = try compiler.compile(memory, source, "filter.zx");

    defer result.deinit(memory);

    if (result == .diagnostic) {
        std.debug.print("{s}\n", .{result.diagnostic.message});

        return error.InvalidSource;
    }

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = result.source });
}
