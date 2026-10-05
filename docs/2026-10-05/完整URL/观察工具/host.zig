const std = @import("std");
const host = @import("url").host;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedModeAndHost;

    const is_opaque = if (std.mem.eql(u8, args[1], "opaque")) true else if (std.mem.eql(u8, args[1], "special")) false else return error.InvalidMode;
    const output = try host.parse(allocator, args[2], is_opaque);

    try std.Io.File.stdout().writeStreamingAll(init.io, output);
}
