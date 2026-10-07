const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = args[1];

    const text = inline for (.{ "plain", "spread", "select", "nested", "subject", "field_call", "escape_call", "root_call", "nested_object", "checked", "initial_call" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ ".zx");
    } else return error.InvalidMode;

    var analysis = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = text },
        .{ .path = "scalar.zx", .source = @embedFile("fixtures/scalar.zx") },
        .{ .path = "step.zx", .source = @embedFile("fixtures/step.zx") },
        .{ .path = "initial.zx", .source = @embedFile("fixtures/initial.zx") },
        .{ .path = "advance.zx", .source = @embedFile("fixtures/advance.zx") },
    }, .{ .entry = "main.zx", .root_dir = "/project" });

    defer analysis.deinit();

    if (analysis.value == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ analysis.value.diagnostic.code, analysis.value.diagnostic.message });

        return error.InvalidAnalysis;
    }

    try emit(init, analysis.value.ir, args[2..4]);

    var library = try compiler.library.link(allocator, &.{.{ .name = "run", .analysis = &analysis }});

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

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
