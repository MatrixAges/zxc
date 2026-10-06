const std = @import("std");
pub var calls = std.atomic.Value(usize).init(0);
pub var worker_calls = std.atomic.Value(usize).init(0);
var parent: std.Thread.Id = 0;

pub fn reset() void {
    parent = std.Thread.getCurrentId();

    calls.store(0, .seq_cst);
    worker_calls.store(0, .seq_cst);
}

fn record() void {
    _ = calls.fetchAdd(1, .seq_cst);

    if (std.Thread.getCurrentId() != parent) _ = worker_calls.fetchAdd(1, .seq_cst);
}

pub fn value(input: u64) error{ NativeFailure, MissingValue }!u64 {
    record();

    return switch (input) {
        0 => error.NativeFailure,
        1 => error.MissingValue,
        else => input,
    };
}

pub fn optional(input: u64) error{NativeFailure}!?u64 {
    record();

    return switch (input) {
        0 => error.NativeFailure,
        1 => null,
        else => input,
    };
}

pub fn effect(input: u64) error{NativeFailure}!void {
    record();

    if (input == 0) return error.NativeFailure;
}

pub fn identity(input: u64) u64 {
    record();

    return input;
}
