const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(1024 * 1024));

    var result = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .externals = &.{
            .{ .specifier = "lib:probe-left", .signature = "export type Input = bool; export type Output = f64;", .implementation = .{ .module = "probe", .member = "left", .fallible = true } },
            .{ .specifier = "lib:probe-right", .signature = "export type Input = bool; export type Output = f64;", .implementation = .{ .module = "probe", .member = "right", .fallible = true } },
        },
    });

    defer result.deinit();

    if (result.value == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ result.value.diagnostic.code, result.value.diagnostic.message });

        return error.CompileFailed;
    }

    const bundle = try compiler.zig.emitBundle(allocator, result.value.ir);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[3], .data = bundle.types });
}
