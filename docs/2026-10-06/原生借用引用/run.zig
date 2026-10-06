const std = @import("std");
const rx = @import("rx");
const walk = @import("walk");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .unlimited);
    var parsed = try rx.parseXml(allocator, source);

    defer parsed.deinit();

    if (parsed.value != .node) return error.InvalidXml;

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const count = try walk.execute(&arena, @ptrCast(&parsed.value.node));
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{ .nodes = count }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}
