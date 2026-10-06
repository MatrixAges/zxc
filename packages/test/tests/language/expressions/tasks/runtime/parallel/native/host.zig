const std = @import("std");
pub const probe = @import("probe.zig");

pub fn first(io: std.Io, input: u64) error{ FirstFailure, Canceled, WaitTimeout, InlineExecution }!u64 {
    probe.start(1, io);
    defer probe.finish(1, io);

    if (!probe.isWorker()) return error.InlineExecution;
    try probe.ready(1, io);
    if ((input & 1) != 0) return error.FirstFailure;

    return (input & 0xff) + 10;
}

pub fn second(io: std.Io, input: u64) error{ SecondFailure, Canceled, WaitTimeout, InlineExecution }!u64 {
    probe.start(2, io);

    defer probe.finish(2, io);

    if (!probe.isWorker()) return error.InlineExecution;
    try probe.ready(2, io);

    if ((input & 2) != 0) return error.SecondFailure;

    return (input & 0xff) + 20;
}

pub fn effect(io: std.Io, input: u64) error{ EffectFailure, Canceled, WaitTimeout, InlineExecution }!void {
    probe.start(3, io);
    defer probe.finish(3, io);

    if (!probe.isWorker()) return error.InlineExecution;
    try probe.ready(3, io);

    if ((input & 8) != 0) return error.EffectFailure;
}
