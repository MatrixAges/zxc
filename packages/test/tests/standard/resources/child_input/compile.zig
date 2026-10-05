const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const text = @embedFile("main.zx");

    var analysis = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = text },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer analysis.deinit();

    if (analysis.value == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ analysis.value.diagnostic.code, analysis.value.diagnostic.message });

        return error.InvalidAnalysis;
    }

    try emit(init, analysis.value.ir, args[1..3]);

    var library = try compiler.library.link(allocator, &.{.{ .name = "run", .analysis = &analysis }});

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    try emit(init, try decoded.module(0), args[3..5]);
}

fn emit(init: std.process.Init, program: compiler.ir.Program, paths: []const []const u8) !void {
    const allocator = init.arena.allocator();

    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = paths[0], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = paths[1], .data = bundle.types });
}
