const std = @import("std");
const pkgs = @import("pkgs");
const store = @import("store");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len < 5 or args.len > 6) return error.ExpectedIndexNameCacheOffline;
    if (args.len == 6 and !std.mem.eql(u8, args[5], "--offline")) return error.InvalidArguments;

    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    const allocator = heap.allocator();
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(16 * 1024 * 1024));

    defer allocator.free(source);

    const index = try pkgs.Index.parse(allocator, source);

    defer index.deinit();

    const release = try index.value.select(args[2], args[3]) orelse return error.PackageVersionNotFound;
    const path = try store.prepare(init.io, allocator, release, std.fs.path.dirname(args[1]) orelse ".", args[4], args.len == 6);

    defer allocator.free(path);

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &buffer);

    try output.interface.print("{s}\n", .{path});
    try output.interface.flush();
}
