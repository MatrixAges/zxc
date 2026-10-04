const std = @import("std");
const backend = @import("backend");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    if (args.len != 2) return error.ExpectedArgumentFile;

    const source = try std.Io.Dir.cwd().readFileAlloc(init.io, args[1], init.arena.allocator(), .limited(1024 * 1024));
    const parsed = try std.json.parseFromSlice([]const []const u8, init.arena.allocator(), source, .{});
    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    var result = try backend.run(init.io, heap.allocator(), parsed.value, init.environ_map);

    defer result.deinit();

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &buffer);

    defer output.interface.flush() catch {};

    var headers: usize = 0;

    for (result.inputs) |input| {
        if (std.mem.endsWith(u8, input.path, ".h")) headers += 1;
    }

    try output.interface.print("success={any} cached={any} complete={any} inputs={d} headers={d} errors={d}\n", .{ result.succeeded, result.cached, result.inputs_complete, result.inputs.len, headers, result.diagnostics.errorMessageCount() });
    try output.interface.writeAll(result.stderr);
    if (!result.succeeded) try result.diagnostics.renderToWriter(.{}, &output.interface);
}
