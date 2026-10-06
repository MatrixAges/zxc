const std = @import("std");
const probe = @import("host").probe;

fn original(userdata: ?*anyopaque) std.Io {
    const threaded: *std.Io.Threaded = @ptrCast(@alignCast(userdata));

    return threaded.io();
}

pub fn concurrent(
    userdata: ?*anyopaque,
    result_len: usize,
    result_alignment: std.mem.Alignment,
    context: []const u8,
    context_alignment: std.mem.Alignment,
    callback: *const fn (*const anyopaque, *anyopaque) void,
) std.Io.ConcurrentError!*std.Io.AnyFuture {
    const index = probe.attempts.fetchAdd(1, .seq_cst);
    const io = original(userdata);

    if (index + 1 == probe.config.fail_at) return error.ConcurrencyUnavailable;

    const future = try io.vtable.concurrent(userdata, result_len, result_alignment, context, context_alignment, callback);

    probe.futures[index] = future;

    probe.wait(&probe.startup_events[index], io) catch @panic("parallel fixture worker did not start before its deadline");

    return future;
}

pub fn wait(userdata: ?*anyopaque, future: *std.Io.AnyFuture, result: []u8, alignment: std.mem.Alignment) void {
    const io = original(userdata);

    _ = probe.awaits.fetchAdd(1, .seq_cst);

    if (probe.config.release_on_await) {
        if (probe.futures[1]) |second| {
            if (future == second) {
                probe.second_awaited_after_first.store(probe.first_done.isSet(), .seq_cst);
                probe.release_second.set(io);
            }
        }
    }

    io.vtable.await(userdata, future, result, alignment);
}

pub fn cancel(userdata: ?*anyopaque, future: *std.Io.AnyFuture, result: []u8, alignment: std.mem.Alignment) void {
    const io = original(userdata);

    _ = probe.cancels.fetchAdd(1, .seq_cst);

    io.vtable.cancel(userdata, future, result, alignment);
}
