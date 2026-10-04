const std = @import("std");
const api = @import("observed");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    if (args.len != 5) return error.ExpectedSourceOutputZigLibrary;

    var inputs = try api.Inputs.init(init.io, allocator);
    defer inputs.deinit();
    try inputs.add(init.io, args[1]);

    const cache = try api.Observed.Cache.init(init.io, allocator, init.environ_map);
    const options: api.Options = .{ .input = args[1], .output = args[2], .assembly = try std.fmt.allocPrint(allocator, "{s}.s", .{args[2]}) };
    const arguments = &.{ args[3], "build-exe", "--listen=-", "--name", "application", "--zig-lib-dir", args[4], "--cache-dir", cache.local, "--global-cache-dir", cache.global, "-femit-asm", "-OReleaseSafe", try std.fmt.allocPrint(allocator, "-Mroot={s}", .{args[1]}) };
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.stdout().writer(init.io, &buffer);
    defer output.interface.flush() catch {};

    for (0..2) |_| {
        var response = try api.Backend.run(init.io, allocator, arguments, init.environ_map);
        var result = api.Observed.resolve(init.io, &response, cache, args[4], options, &inputs) catch |err| {
            response.deinit();
            return err;
        };
        defer result.deinit();

        const published = try result.publish(init.io, allocator, &inputs, options);
        const row = try std.json.Stringify.valueAlloc(allocator, .{
            .succeeded = result.response.succeeded,
            .cached = result.response.cached,
            .new_inputs = result.new_inputs,
            .published = published,
            .errors = result.response.diagnostics.errorMessageCount(),
            .inputs = result.input_paths.len,
        }, .{});
        try output.interface.print("{s}\n", .{row});
        try output.interface.flush();
    }
}
