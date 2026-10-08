const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    for (args[1..]) |path| {
        const source = try std.Io.Dir.cwd().readFileAlloc(init.io, path, allocator, .unlimited);
        var formatted = try compiler.format(allocator, source, path);

        defer formatted.deinit(allocator);

        try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = formatted.source });
    }
}
