const std = @import("std");
pub const Stage = enum { subject, pattern, amount };
pub const Event = struct { stage: Stage, value: u64 };
pub const Failure = struct { stage: ?Stage = null, occurrence: usize = 1 };
pub var trace: [49152]Event = undefined;
pub var calls: usize = 0;
var counts: [3]usize = undefined;
var failure: Failure = .{};

pub fn reset(requested: Failure) void {
    failure = requested;
    counts = .{ 0, 0, 0 };
    calls = 0;
}

fn record(stage: Stage, value: u64) bool {
    std.debug.assert(calls < trace.len);

    trace[calls] = .{ .stage = stage, .value = value };
    calls += 1;

    counts[@backingInt(stage)] += 1;

    return failure.stage == stage and counts[@backingInt(stage)] == failure.occurrence;
}

pub fn subject(value: u64) error{SubjectFailure}!u64 {
    if (record(.subject, value)) return error.SubjectFailure;

    return value % 3;
}

pub fn pattern(value: u64) error{PatternFailure}!u64 {
    if (record(.pattern, value)) return error.PatternFailure;

    return value;
}

pub fn amount(value: u64) error{AmountFailure}!u64 {
    if (record(.amount, value)) return error.AmountFailure;

    return value;
}
