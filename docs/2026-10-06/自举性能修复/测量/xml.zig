const std = @import("std");
const generated = @import("generated");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], init.arena.allocator(), .unlimited);
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);

    defer arena.deinit();

    const result = try generated.execute(&arena, &.{ .source = source, .expressions = true });
    var buffer: [4096]u8 = undefined;
    var hashing = std.Io.Writer.Hashing(std.crypto.hash.sha2.Sha256).init(&buffer);

    try std.json.Stringify.value(result, .{}, &hashing.writer);
    try hashing.writer.flush();

    const digest = std.fmt.bytesToHex(hashing.hasher.finalResult(), .lower);
    var output = std.Io.File.Writer.initStreaming(.stdout(), init.io, &buffer);

    try std.json.Stringify.value(.{
        .source_bytes = source.len,
        .nodes = result.tree.nodes.len,
        .attributes = result.tree.attributes.len,
        .arena_bytes = arena.queryCapacity(),
        .diagnostic = result.control.message,
        .digest = &digest,
    }, .{}, &output.interface);

    try output.interface.writeByte('\n');
    try output.interface.flush();
}
