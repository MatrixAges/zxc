const std = @import("std");
pub const Event = struct { slot: u64, fail: bool };
pub var calls: usize = 0;
pub var events: [8]Event = undefined;

pub fn reset() void {
    calls = 0;
}

pub fn index(input: anytype) error{SelectionFailed}!u64 {
    std.debug.assert(calls < events.len);

    events[calls] = .{ .slot = input.slot, .fail = input.fail };
    calls += 1;

    if (input.fail) return error.SelectionFailed;

    return input.slot;
}
