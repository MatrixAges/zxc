const std = @import("std");
pub var completed_starts = std.atomic.Value(usize).init(0);
pub var started = std.atomic.Value(usize).init(0);
pub var finished = std.atomic.Value(usize).init(0);
pub var workers = std.atomic.Value(usize).init(0);
pub var canceled = std.atomic.Value(usize).init(0);
pub var after_calls = std.atomic.Value(usize).init(0);
pub var outer_calls = std.atomic.Value(usize).init(0);
pub var released = std.atomic.Value(usize).init(0);
pub var controller_failed = std.atomic.Value(bool).init(false);
pub var hold_cleanup = false;
pub var started_event: std.Io.Event = .unset;
pub var finished_event: std.Io.Event = .unset;
pub var pending_event: std.Io.Event = .unset;
pub var canceled_event: std.Io.Event = .unset;
pub var release_event: std.Io.Event = .unset;

var parent: std.Thread.Id = 0;

pub fn reset(hold: bool) void {
    parent = std.Thread.getCurrentId();
    hold_cleanup = hold;

    completed_starts.store(0, .seq_cst);
    started.store(0, .seq_cst);
    finished.store(0, .seq_cst);
    workers.store(0, .seq_cst);
    canceled.store(0, .seq_cst);
    after_calls.store(0, .seq_cst);
    outer_calls.store(0, .seq_cst);
    released.store(0, .seq_cst);
    controller_failed.store(false, .seq_cst);

    started_event = .unset;
    finished_event = .unset;
    pending_event = .unset;
    canceled_event = .unset;
    release_event = .unset;
}

pub fn isWorker() bool {
    return std.Thread.getCurrentId() != parent;
}

pub fn start(io: std.Io) void {
    _ = started.fetchAdd(1, .seq_cst);

    if (isWorker()) _ = workers.fetchAdd(1, .seq_cst);

    started_event.set(io);
}

pub fn finish(io: std.Io) void {
    _ = finished.fetchAdd(1, .seq_cst);

    finished_event.set(io);
}

pub fn acknowledge(io: std.Io) void {
    _ = canceled.fetchAdd(1, .seq_cst);

    canceled_event.set(io);

    if (hold_cleanup) release_event.waitUncancelable(io);
}

pub fn wait(event: *std.Io.Event, io: std.Io) error{ Canceled, WaitTimeout }!void {
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

pub fn controller(io: std.Io) void {
    wait(&canceled_event, io) catch {
        controller_failed.store(true, .seq_cst);
        release_event.set(io);

        return;
    };

    _ = released.fetchAdd(1, .seq_cst);

    release_event.set(io);
}

pub fn releaseAll(io: std.Io) void {
    pending_event.set(io);
    canceled_event.set(io);
    release_event.set(io);
}
