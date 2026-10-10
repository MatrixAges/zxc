const std = @import("std");
const f = @import("fixture.zig");
const library = @import("library.zig");

fn emit(init: std.process.Init, program: f.ir.Program, path: []const u8) !void {
    const result = try f.compiler.zig.emit(init.arena.allocator(), program);

    defer init.arena.allocator().free(result);

    try std.Io.Dir.cwd().writeFile(init.io, .{ .sub_path = path, .data = result });
}

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 4) return error.ExpectedOrderingRouteAndOutput;

    const order = try std.fmt.parseInt(usize, args[1], 10);

    if (order >= f.orderings.len) return error.InvalidOrdering;

    var decoded = block: {
        var analysis = try f.analyze(std.heap.page_allocator, f.orderings[order], true);

        defer analysis.deinit();

        var artifacts: [4]f.artifact.Result = undefined;
        var values: [4]f.artifact.Module = undefined;
        var count: usize = 0;

        defer for (artifacts[0..count]) |*result| result.deinit();

        for (&artifacts, &values, 0..) |*result, *value, index| {
            result.* = try f.artifact.extract(std.heap.page_allocator, &analysis, index);
            value.* = result.value;
            count += 1;
        }

        var linked = try f.artifact.linker.link(std.heap.page_allocator, &values, "/project/main.zx");

        defer linked.deinit();

        try std.testing.expectEqual(null, try f.compiler.validateIr(init.arena.allocator(), linked.program));

        if (std.mem.eql(u8, args[2], "source")) return emit(init, linked.program, args[3]);
        if (!std.mem.eql(u8, args[2], "library")) return error.InvalidRoute;

        break :block try library.decode(init.arena.allocator(), analysis, linked);
    };

    defer decoded.deinit();

    var consumer = try library.consume(init.arena.allocator(), &decoded);

    defer consumer.deinit();

    try emit(init, consumer.value.ir, args[3]);
}
