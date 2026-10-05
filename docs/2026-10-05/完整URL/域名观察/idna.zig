const std = @import("std");
const idna = @import("idna");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 3) return error.ExpectedOperationAndText;

    const output = if (std.mem.eql(u8, args[1], "ascii"))
        try idna.toAscii(allocator, args[2])

    else if (std.mem.eql(u8, args[1], "unicode"))
        try idna.toUnicode(allocator, args[2])
    else
        return error.InvalidOperation;

    try std.Io.File.stdout().writeStreamingAll(init.io, output);
}
