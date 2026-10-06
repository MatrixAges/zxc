const std = @import("std");
const probe = @import("host").probe;

pub fn start(
    userdata: ?*anyopaque,
    result: []u8,
    result_alignment: std.mem.Alignment,
    context: []const u8,
    context_alignment: std.mem.Alignment,
    callback: *const fn (*const anyopaque, *anyopaque) void,
) ?*std.Io.AnyFuture {
    const threaded: *std.Io.Threaded = @ptrCast(@alignCast(userdata));
    const io = threaded.io();

    if (io.vtable.async(userdata, result, result_alignment, context, context_alignment, callback)) |future| {
        io.vtable.await(userdata, future, result, result_alignment);
    }

    _ = probe.completed_starts.fetchAdd(1, .seq_cst);

    return null;
}
