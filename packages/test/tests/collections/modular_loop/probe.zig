const std = @import("std");
pub var calls: usize = 0;
pub var events: [128]u64 = undefined;
pub var fail_token: u64 = std.math.maxInt(u64);

pub fn reset(token: u64) void {
    calls = 0;
    fail_token = token;
}

pub fn observe(token: u64) error{ProbeFailed}!u64 {
    std.debug.assert(calls < events.len);

    events[calls] = token;
    calls += 1;

    if (token == fail_token) return error.ProbeFailed;

    return token + 5;
}
