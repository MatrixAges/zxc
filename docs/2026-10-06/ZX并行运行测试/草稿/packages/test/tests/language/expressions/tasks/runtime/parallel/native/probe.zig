const std = @import("std");

pub const Config = struct {
    branches: usize = 2,
    reverse_completion: bool = true,
    release_on_await: bool = false,
    fail_at: usize = 0,
};

pub const Error = error{ Canceled, WaitTimeout };
pub var config: Config = .{};
pub var attempts = std.atomic.Value(usize).init(0);
pub var awaits = std.atomic.Value(usize).init(0);
pub var cancels = std.atomic.Value(usize).init(0);
pub var arrivals = std.atomic.Value(usize).init(0);
pub var finished = std.atomic.Value(usize).init(0);
pub var workers = std.atomic.Value(usize).init(0);
pub var active = std.atomic.Value(usize).init(0);
pub var overlap = std.atomic.Value(usize).init(0);
pub var canceled = std.atomic.Value(usize).init(0);
pub var second_awaited_after_first = std.atomic.Value(bool).init(false);
pub var arrival_trace: [3]u8 = .{ 0, 0, 0 };
pub var completion_trace: [3]u8 = .{ 0, 0, 0 };
pub var futures: [3]?*std.Io.AnyFuture = .{ null, null, null };
pub var startup_events: [3]std.Io.Event = .{ .unset, .unset, .unset };
pub var gate: std.Io.Event = .unset;
pub var first_done: std.Io.Event = .unset;
pub var second_done: std.Io.Event = .unset;
pub var release_second: std.Io.Event = .unset;

var parent: std.Thread.Id = 0;

pub fn reset(value: Config) void {
    config = value;
    parent = std.Thread.getCurrentId();

    attempts.store(0, .seq_cst);
    awaits.store(0, .seq_cst);
    cancels.store(0, .seq_cst);
    arrivals.store(0, .seq_cst);
    finished.store(0, .seq_cst);
    workers.store(0, .seq_cst);
    active.store(0, .seq_cst);
    overlap.store(0, .seq_cst);
    canceled.store(0, .seq_cst);
    second_awaited_after_first.store(false, .seq_cst);
    @memset(&arrival_trace, 0);
    @memset(&completion_trace, 0);
    @memset(&futures, null);
    @memset(&startup_events, .unset);

    gate = .unset;
    first_done = .unset;
    second_done = .unset;
    release_second = .unset;
}

pub fn isWorker() bool {
    return std.Thread.getCurrentId() != parent;
}

pub fn start(tag: u8, io: std.Io) void {
    _ = active.fetchAdd(1, .seq_cst);

    const index = arrivals.fetchAdd(1, .seq_cst);
    arrival_trace[index] = tag;

    if (isWorker()) _ = workers.fetchAdd(1, .seq_cst);

    startup_events[index].set(io);

    if (index + 1 == config.branches) {
        overlap.store(active.load(.seq_cst), .seq_cst);
        gate.set(io);
    }
}

pub fn ready(tag: u8, io: std.Io) Error!void {
    try cancelableWait(&gate, io);

    if (tag == 1 and config.reverse_completion) try cancelableWait(&second_done, io);
    if (tag == 2 and config.release_on_await) try cancelableWait(&release_second, io);
}

fn cancelableWait(event: *std.Io.Event, io: std.Io) Error!void {
    wait(event, io) catch |err| {
        if (err == error.Canceled) _ = canceled.fetchAdd(1, .seq_cst);

        return err;
    };
}

pub fn finish(tag: u8, io: std.Io) void {
    const index = finished.fetchAdd(1, .seq_cst);

    completion_trace[index] = tag;
    _ = active.fetchSub(1, .seq_cst);

    if (tag == 1) first_done.set(io);
    if (tag == 2) second_done.set(io);
}

pub fn wait(event: *std.Io.Event, io: std.Io) Error!void {
    const deadline = std.Io.Clock.Timestamp.fromNow(io, .{ .raw = .fromSeconds(5), .clock = .awake });

    while (true) {
        event.waitTimeout(io, .{ .deadline = deadline }) catch |err| switch (err) {
            error.Canceled => return error.Canceled,
            error.Timeout => {
                if (std.Io.Clock.Timestamp.compare(.now(io, .awake), .gte, deadline)) return error.WaitTimeout;

                continue;
            },
        };

        return;
    }
}

pub fn releaseAll(io: std.Io) void {
    gate.set(io);
    first_done.set(io);
    second_done.set(io);
    release_second.set(io);
}
