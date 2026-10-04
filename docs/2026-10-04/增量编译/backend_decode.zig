const std = @import("std");
const backend = @import("backend");

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var heap: std.heap.DebugAllocator(.{}) = .init;

    defer std.debug.assert(heap.deinit() == .ok);

    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &buffer);

    defer output.interface.flush() catch {};

    for (args[1..]) |path| {
        var result = block: {
            const bytes = try std.Io.Dir.cwd().readFileAlloc(init.io, path, heap.allocator(), .limited(128 * 1024 * 1024));

            defer heap.allocator().free(bytes);

            break :block backend.decode(heap.allocator(), bytes, "", .{ .exited = 0 }) catch |err| {
                if (err == error.OutOfMemory) return err;

                try output.interface.print("{s}: {s}\n", .{ path, @errorName(err) });

                continue;
            };
        };

        defer result.deinit();

        var headers: usize = 0;

        for (result.inputs) |input| {
            if (std.mem.endsWith(u8, input.path, ".h")) headers += 1;
        }

        try output.interface.print("{s}: success={any} cached={any} complete={any} inputs={d} headers={d} errors={d}\n", .{ path, result.succeeded, result.cached, result.inputs_complete, result.inputs.len, headers, result.diagnostics.errorMessageCount() });
        if (!result.succeeded) try result.diagnostics.renderToWriter(.{}, &output.interface);
    }
}
