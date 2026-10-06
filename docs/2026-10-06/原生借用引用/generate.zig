const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var analyzed = try compiler.project.analyze(allocator, &.{
        .{ .path = "walk.zx", .source = @embedFile("walk.zx") },
        .{ .path = "initial.zx", .source = @embedFile("initial.zx") },
        .{ .path = "model.zx", .source = @embedFile("model.zx") },
    }, .{
        .entry = "walk.zx",
        .root_dir = "/draft",
        .native_interfaces = &.{.{ .specifier = "zig:ast", .path = "ast.d.zx", .source = @embedFile("ast.d.zx"), .module = "ast" }},
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});

        return error.InvalidTraversal;
    }

    const generated = try compiler.zig.emitBundle(allocator, analyzed.value.ir);

    defer allocator.free(generated.source);
    defer allocator.free(generated.types);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[1], .data = generated.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = generated.types });
}
