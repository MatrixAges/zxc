const std = @import("std");
const compiler = @import("compiler");
const fixture = @import("fixture.zig");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len != 6) return error.ExpectedModeAndFourOutputs;

    var decoded = block: {
        var result = try fixture.analyze(std.heap.page_allocator, args[1]);

        defer result.deinit();

        if (result.value == .diagnostic) {
            std.debug.print("{s}: {t}: {s}\n", .{ args[1], result.value.diagnostic.code, result.value.diagnostic.message });

            return error.InvalidAnalysis;
        }

        try emit(init, result.value.ir, args[2..4]);

        var library = try compiler.library.link(std.heap.page_allocator, &.{.{ .name = "run", .analysis = &result }});

        defer library.deinit();

        const bytes = try compiler.library.codec.encode(std.heap.page_allocator, &library);

        defer std.heap.page_allocator.free(bytes);

        const restored = try compiler.library.codec.decode(allocator, bytes);

        @memset(bytes, 0xdd);

        break :block restored;
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
}
