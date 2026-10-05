const std = @import("std");
const library = @import("library");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 2) return error.ExpectedUrl;

    const output = try library.execute(init.arena, &.{ .url = args[1], .method = .Get, .headers = &.{}, .body = null, .max_body_bytes = 1024, .max_header_bytes = 8192 }, init.io);
    var buffer: [4096]u8 = undefined;
    var writer = std.Io.File.stdout().writerStreaming(init.io, &buffer);

    try std.json.Stringify.value(output, .{}, &writer.interface);
    try writer.interface.flush();
}
