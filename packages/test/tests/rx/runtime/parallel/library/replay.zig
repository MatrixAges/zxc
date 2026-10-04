const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 5) return error.ExpectedArtifactExportAndOutputs;

    var library = block: {
        const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], std.heap.page_allocator, .limited(16 * 1024 * 1024));

        defer std.heap.page_allocator.free(bytes);

        var decoded = try compiler.library.codec.decode(allocator, bytes);

        errdefer decoded.deinit();

        const encoded = try compiler.library.codec.encode(allocator, &decoded);

        defer allocator.free(encoded);

        try std.testing.expectEqualStrings(bytes, encoded);

        @memset(bytes, 0);

        break :block decoded;
    };

    defer library.deinit();

    const index = for (library.exports, 0..) |exported, index| {
        if (std.mem.eql(u8, exported.name, args[2])) break index;
    } else return error.MissingExport;

    const program = try library.module(index);

    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[4], .data = bundle.types });
}
