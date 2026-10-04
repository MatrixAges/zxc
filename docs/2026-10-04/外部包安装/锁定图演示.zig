const std = @import("std");
const pkgs = @import("pkgs");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) return error.ExpectedLockFile;

    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    const allocator = heap.allocator();
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(32 * 1024 * 1024));

    defer allocator.free(source);

    const parsed = try pkgs.Lock.parse(allocator, source);

    defer parsed.deinit();

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &buffer);

    try std.json.Stringify.value(parsed.value, .{ .whitespace = .indent_2 }, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}
