const std = @import("std");
const library = @import("library");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) return error.ExpectedValue;

    const input = try std.fmt.parseFloat(f64, args[1]);
    const output = try library.execute(init.arena, input);
    var buffer: [256]u8 = undefined;
    var writer = std.Io.File.Writer.init(.stdout(), init.io, &buffer);

    try writer.interface.print("{d}\n", .{output});
    try writer.interface.flush();
}
