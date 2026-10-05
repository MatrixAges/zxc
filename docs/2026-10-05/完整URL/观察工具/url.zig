const std = @import("std");
const url = @import("url");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const with_origin = args.len > 1 and std.mem.eql(u8, args[1], "--origin");
    const offset: usize = if (with_origin) 2 else 1;

    if (args.len < offset + 1 or args.len > offset + 2) return error.ExpectedUrlAndOptionalBase;

    var parsed = try url.parse(allocator, args[offset], if (args.len == offset + 2) args[offset + 1] else null);

    defer parsed.deinit();

    const output = if (with_origin) try url.origin(allocator, parsed.value) else try url.serialize(allocator, parsed.value, false);

    try std.Io.File.stdout().writeStreamingAll(init.io, output);
}
