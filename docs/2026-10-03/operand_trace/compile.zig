const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], allocator, .limited(1024 * 1024));

    const result = try compiler.compileProject(allocator, &.{.{ .path = "main.zx", .source = source }}, .{
        .entry = "main.zx",
        .externals = &.{
            .{ .specifier = "lib:probe-left", .signature = "export type Input = bool; export type Output = f64;", .implementation = .{ .module = "probe", .member = "left", .fallible = true } },
            .{ .specifier = "lib:probe-right", .signature = "export type Input = bool; export type Output = f64;", .implementation = .{ .module = "probe", .member = "right", .fallible = true } },
        },
    });

    defer result.deinit(allocator);

    if (result == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ result.diagnostic.code, result.diagnostic.message });

        return error.CompileFailed;
    }

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = result.source });
}
