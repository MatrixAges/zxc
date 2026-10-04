const std = @import("std");
const application = @import("application");
const Tracking = @import("tracking.zig");

pub fn main(init: std.process.Init) !void {
    var debug: std.heap.DebugAllocator(.{ .enable_memory_limit = true }) = .init;

    defer if (debug.deinit() == .leak) @panic("parallel example leaked memory");

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const input = try std.json.parseFromSliceLeaky(application.Input, init.arena.allocator(), args[1], .{ .allocate = .alloc_always });
    var buffer: [4096]u8 = undefined;
    var output = std.Io.File.Writer.init(.stdout(), init.io, &buffer);
    const workers = try observe(debug.allocator(), input, &output.interface);

    try std.json.Stringify.value(.{ .worker_allocation_threads = workers, .remaining_bytes = debug.total_requested_bytes }, .{}, &output.interface);
    try output.interface.writeByte('\n');
    try output.interface.flush();
}

fn observe(allocator: std.mem.Allocator, input: application.Input, writer: *std.Io.Writer) !usize {
    var tracking = Tracking{ .child = allocator };

    defer tracking.threads.deinit(allocator);

    try execute(&tracking, input, writer);

    var workers: usize = 0;
    var threads = tracking.threads.keyIterator();

    while (threads.next()) |id| {
        if (id.* != std.Thread.getCurrentId()) workers += 1;
    }

    return workers;
}

fn execute(tracking: *Tracking, input: application.Input, writer: *std.Io.Writer) !void {
    var arena = std.heap.ArenaAllocator.init(tracking.allocator());

    defer arena.deinit();

    if (application.execute(&arena, input)) |result| {
        try std.json.Stringify.value(.{ .output = result }, .{}, writer);
    } else |err| {
        try std.json.Stringify.value(.{ .failure = @errorName(err) }, .{}, writer);
    }

    try writer.writeByte('\n');
}
