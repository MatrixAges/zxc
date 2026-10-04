const std = @import("std");
const compiler = @import("compiler");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    const result = try compiler.compileWithContext(allocator, @embedFile("cases/store.zx"), "store.zx", .{
        .stores = &.{.{ .handle = "$store_v", .path = "store.orders.state", .type_name = "State" }},
    });

    defer result.deinit(allocator);

    if (result == .diagnostic) {
        std.debug.print("{t}: {s}\n", .{ result.diagnostic.code, result.diagnostic.message });

        return error.CompileFailed;
    }

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = args[1], .data = result.source });
}
