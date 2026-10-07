const std = @import("std");
pub const Stage = enum { source, index, value, after, container };
pub const Event = struct { stage: Stage, payload: i64, sample: i64 };
pub const Failure = struct { stage: ?Stage = null, occurrence: usize = 1 };
pub var events: [1024]Event = undefined;
pub var calls: usize = 0;
var counts: [5]usize = undefined;
var failure: Failure = .{};
var selected_index: usize = 0;

pub fn reset(requested: Failure, index_value: usize) void {
    failure = requested;
    selected_index = index_value;
    counts = .{ 0, 0, 0, 0, 0 };
    calls = 0;
}

fn record(stage: Stage, payload: i64, sample: i64) bool {
    std.debug.assert(calls < events.len);

    events[calls] = .{ .stage = stage, .payload = payload, .sample = sample };
    calls += 1;

    counts[@intFromEnum(stage)] += 1;

    return failure.stage == stage and counts[@intFromEnum(stage)] == failure.occurrence;
}

pub fn source(values: []const i64) error{SourceFailure}![]const i64 {
    if (record(.source, @intCast(values.len), if (selected_index < values.len) values[selected_index] else 0)) return error.SourceFailure;

    return values;
}

pub fn index(selected: u64) error{IndexFailure}!u64 {
    if (record(.index, @intCast(selected), 0)) return error.IndexFailure;

    return selected;
}

pub fn value(delta: i64) error{ValueFailure}!i64 {
    if (record(.value, delta, 0)) return error.ValueFailure;

    return delta;
}

pub fn after(round: u64) error{AfterFailure}!u64 {
    if (record(.after, @intCast(round), 0)) return error.AfterFailure;

    return round;
}

pub fn container(selected: u64) error{ContainerFailure}!u64 {
    if (record(.container, @intCast(selected), 0)) return error.ContainerFailure;

    return selected;
}
