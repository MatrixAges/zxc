const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = args[1];
    const sources = try @import("fixture.zig").sources(mode);

    var decoded = block: {
        var analysis = try compiler.project.analyze(std.heap.page_allocator, &sources, .{
            .entry = "main.zx",
            .root_dir = "/project",
        });

        defer analysis.deinit();

        if (analysis.value == .diagnostic) {
            std.debug.print("{s}: {t}: {s}\n", .{ mode, analysis.value.diagnostic.code, analysis.value.diagnostic.message });

            return error.InvalidAnalysis;
        }

        try emit(init, analysis.value.ir, args[2..4]);

        var library = try compiler.library.link(std.heap.page_allocator, &.{.{ .name = "run", .analysis = &analysis }});

        defer library.deinit();

        const bytes = try compiler.library.codec.encode(std.heap.page_allocator, &library);

        defer std.heap.page_allocator.free(bytes);

        const result = try compiler.library.codec.decode(allocator, bytes);

        @memset(bytes, 0);

        break :block result;
    };

    defer decoded.deinit();

    try emit(init, try decoded.module(0), args[4..6]);
}

fn emit(init: std.process.Init, program: compiler.ir.Program, paths: []const []const u8) !void {
    const allocator = init.arena.allocator();

    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = paths[0], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = paths[1], .data = bundle.types });
    try @import("shape.zig").check(bundle.source, program);
}
