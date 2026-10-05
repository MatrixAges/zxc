const std = @import("std");
const rx = @import("rx");
const gateway = @import("rx_analysis").gateway;

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 2) return error.ExpectedFile;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(1024 * 1024));
    var parsed = try rx.parseXml(allocator, source);

    defer parsed.deinit();

    if (parsed.value != .node) return error.InvalidXml;

    var result = try gateway.analyze(allocator, .{ .owner = "api/main.gateway.rx", .node = parsed.value.node });

    defer result.deinit();

    var buffer: [4096]u8 = undefined;
    var writer = std.Io.File.stdout().writerStreaming(init.io, &buffer);

    try std.json.Stringify.value(result.value, .{}, &writer.interface);
    try writer.interface.flush();
}
