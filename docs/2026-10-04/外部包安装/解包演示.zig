const std = @import("std");
const archive = @import("archive");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 4) return error.ExpectedArchiveDestinationDigest;

    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    const allocator = heap.allocator();
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(archive.maximum_archive));

    defer allocator.free(source);

    var digest: [32]u8 = undefined;

    if (args[3].len != 64) return error.InvalidDigest;

    _ = try std.fmt.hexToBytes(&digest, args[3]);

    try std.Io.Dir.cwd().createDir(init.io, args[2], .default_dir);

    errdefer std.Io.Dir.cwd().deleteTree(init.io, args[2]) catch {};

    var directory = try std.Io.Dir.cwd().openDir(init.io, args[2], .{});

    defer directory.close(init.io);

    var result = try archive.extract(init.io, allocator, source, digest, directory);

    defer result.deinit();

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &buffer);

    try std.json.Stringify.value(result.files, .{ .whitespace = .indent_2 }, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}
