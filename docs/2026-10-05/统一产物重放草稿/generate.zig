const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len != 3) return error.ExpectedOrderAndDirectory;
    const archive = std.mem.startsWith(u8, args[1], "archive_");
    const order = if (archive) args[1]["archive_".len..] else args[1];

    var library = if (std.mem.startsWith(u8, order, "mixed")) try @import("mixed.zig").link(allocator, std.mem.endsWith(u8, order, "reverse")) else block: {
        const sources = [_]compiler.project.Source{
            .{ .path = "alpha.zx", .source = @embedFile("fixtures/alpha.zx") },
            .{ .path = "beta.zx", .source = @embedFile("fixtures/beta.zx") },
            .{ .path = "leaf.zx", .source = @embedFile("fixtures/leaf.zx") },
            .{ .path = "tail.zx", .source = @embedFile("fixtures/tail.zx") },
        };
        var alpha = try compiler.project.analyze(std.heap.page_allocator, &sources, .{ .entry = "alpha.zx", .root_dir = "/project" });
        defer alpha.deinit();
        var beta = try compiler.project.analyze(std.heap.page_allocator, &sources, .{ .entry = "beta.zx", .root_dir = "/project" });
        defer beta.deinit();
        if (alpha.value != .ir or beta.value != .ir) return error.InvalidFixture;

        var inputs = [_]compiler.library.Input{
            .{ .name = "alpha", .analysis = &alpha },
            .{ .name = "beta", .analysis = &beta },
            .{ .name = "repeat", .analysis = &alpha },
        };
        if (std.mem.eql(u8, order, "reverse")) std.mem.reverse(compiler.library.Input, &inputs);

        break :block try compiler.library.link(allocator, &inputs);
    };
    defer library.deinit();

    if (archive) {
        const bytes = try compiler.library.codec.encode(allocator, &library);
        defer allocator.free(bytes);
        var file = try std.Io.Dir.cwd().createFileAtomic(init.io, args[2], .{ .make_path = true, .replace = true });
        defer file.deinit(init.io);
        try file.file.writeStreamingAll(init.io, bytes);
        try file.replace(init.io);
        return;
    }

    try @import("emit.zig").emit(init.io, allocator, &library, args[2]);
}
