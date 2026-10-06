const std = @import("std");
pub const probe = @import("probe.zig");

pub fn block(io: std.Io, input: u64) error{ Canceled, TaskFailure, InlineExecution, WaitTimeout }!u64 {
    probe.start(io);
    defer probe.finish(io);

    if (!probe.isWorker()) return error.InlineExecution;

    probe.wait(&probe.pending_event, io) catch |err| {
        if (err == error.Canceled) {
            probe.acknowledge(io);

            return if (input == 0) error.TaskFailure else error.Canceled;
        }

        return err;
    };

    return input;
}

pub fn complete(io: std.Io, input: u64) error{TaskFailure}!u64 {
    probe.start(io);
    defer probe.finish(io);

    return if (input == 0) error.TaskFailure else input;
}

pub fn waitStarted(io: std.Io, input: u64) error{ Canceled, WaitTimeout }!void {
    _ = input;

    try probe.wait(&probe.started_event, io);
}

pub fn waitFinished(io: std.Io, input: u64) error{ Canceled, WaitTimeout }!void {
    _ = input;

    try probe.wait(&probe.finished_event, io);
}

pub fn after(input: u64) error{CleanupIncomplete}!u64 {
    _ = probe.after_calls.fetchAdd(1, .seq_cst);

    if (probe.finished.load(.seq_cst) != 1) return error.CleanupIncomplete;

    return input;
}

pub fn outerFailure(input: u64) error{OuterFailure}!u64 {
    _ = input;
    _ = probe.outer_calls.fetchAdd(1, .seq_cst);

    return error.OuterFailure;
}
