const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const mode = args[1];

    const text = inline for (.{ "stack", "nested", "two_lanes", "bounds", "old_list", "call", "escaping", "consumer" }) |name| {
        if (std.mem.eql(u8, mode, name)) break @embedFile("fixtures/" ++ name ++ ".zx");
    } else return error.InvalidMode;

    var analysis = try compiler.project.analyze(allocator, &.{
        .{ .path = "main.zx", .source = text },
        .{ .path = "read_frame.zx", .source = @embedFile("fixtures/read_frame.zx") },
    }, .{
        .entry = "main.zx",
        .root_dir = "/project",
        .native_interfaces = if (std.mem.eql(u8, mode, "consumer")) &.{.{ .specifier = "zig:choose", .path = "interface.d.zx", .source = @embedFile("fixtures/interface.d.zx"), .module = "choose" }} else &.{},
    });

    defer analysis.deinit();

    if (analysis.value == .diagnostic) {
        std.debug.print("{s}: {t}: {s}\n", .{ mode, analysis.value.diagnostic.code, analysis.value.diagnostic.message });

        return error.InvalidAnalysis;
    }

    try emit(init, analysis.value.ir, mode, args[2..4]);

    var library = try compiler.library.link(allocator, &.{.{ .name = "run", .analysis = &analysis }});

    defer library.deinit();

    const bytes = try compiler.library.codec.encode(allocator, &library);

    defer allocator.free(bytes);

    var decoded = try compiler.library.codec.decode(allocator, bytes);

    defer decoded.deinit();

    try emit(init, try decoded.module(0), mode, args[4..6]);
}

fn emit(init: std.process.Init, program: compiler.ir.Program, mode: []const u8, paths: []const []const u8) !void {
    const allocator = init.arena.allocator();

    if (try compiler.validateIr(allocator, program) != null) return error.InvalidIr;

    const bundle = try compiler.zig.emitBundle(allocator, program);

    defer bundle.deinit(allocator);

    try @import("shape.zig").check(bundle.source, mode);
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = paths[0], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = paths[1], .data = bundle.types });
}
