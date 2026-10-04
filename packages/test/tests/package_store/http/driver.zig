const std = @import("std");
const store = @import("package_store");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len != 5) return error.ExpectedSourceDigestCacheOffline;
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &buffer);
    const path = store.prepare(init.io, allocator, .{ .version = "1.0.0", .archive = args[1], .sha256 = args[2] }, ".", args[3], std.mem.eql(u8, args[4], "true")) catch |err| {
        try output.interface.print("error:{s}\n", .{@errorName(err)});
        try output.interface.flush();
        std.process.exit(1);
    };
    defer allocator.free(path);

    try output.interface.print("{s}\n", .{path});
    try output.interface.flush();
}
