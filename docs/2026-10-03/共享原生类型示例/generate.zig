const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    var analyzed = try compiler.analyzeProject(allocator, &.{.{ .path = "main.zx", .source = @embedFile("main.zx") }}, .{
        .entry = "main.zx",
        .native_interfaces = &.{.{ .specifier = "zig:transport", .path = "transport.d.zx", .source = @embedFile("transport.d.zx"), .module = "transport" }},
    });

    defer analyzed.deinit();

    if (analyzed.value == .diagnostic) {
        std.debug.print("{s}\n", .{analyzed.value.diagnostic.message});

        return error.InvalidSource;
    }

    const bundle = try compiler.zig.emitBundle(allocator, analyzed.value.ir);

    defer bundle.deinit(allocator);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[1], .data = bundle.source });
    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[2], .data = bundle.types });
}
