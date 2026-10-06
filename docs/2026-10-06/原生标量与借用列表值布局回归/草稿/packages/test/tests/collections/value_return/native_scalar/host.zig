const std = @import("std");
pub const Event = struct { marker: u8, value: u64 };
pub var calls: usize = 0;
pub var fail_at: usize = 0;
pub var oom_calls: ?usize = null;
pub var oom_failures: usize = 0;
pub var events: [512]Event = undefined;

pub fn reset(failure: usize) void {
    calls = 0;
    fail_at = failure;
    oom_calls = null;
    events = undefined;
}

fn record(marker: u8, value: u64) error{NativeFailure}!u64 {
    events[calls] = .{ .marker = marker, .value = value };
    calls += 1;

    if (calls == fail_at) return error.NativeFailure;

    return value;
}

pub fn first(value: u64) error{NativeFailure}!u64 {
    return record(1, value);
}

pub fn second(value: u64) error{NativeFailure}!u64 {
    return record(2, value);
}

pub fn allocated(allocator: std.mem.Allocator, value: u64) error{ NativeFailure, OutOfMemory }!u64 {
    const recorded = try record(3, value);

    const item = allocator.create(u64) catch |err| {
        oom_calls = calls;
        oom_failures += 1;

        return err;
    };

    item.* = recorded;

    return item.*;
}
