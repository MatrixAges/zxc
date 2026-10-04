const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len != 3) return error.ExpectedArtifactAndDirectory;

    var library = block: {
        const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], std.heap.page_allocator, .limited(16 * 1024 * 1024));
        defer std.heap.page_allocator.free(bytes);
        const result = try compiler.library.codec.decode(allocator, bytes);
        @memset(bytes, 0);
        break :block result;
    };
    defer library.deinit();

    try @import("emit.zig").emit(init.io, allocator, &library, args[2]);
}
