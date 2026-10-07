const std = @import("std");
const host = @import("host");
const h = @import("check.zig");
const allocation_testing = @import("allocation_testing");

fn failures(stage: host.Stage) !void {
    var occurrences: usize = 0;

    for (0..31) |index| {
        if (stage == .subject or (index % 7) % 3 != 0) occurrences += 1;
    }

    for (1..occurrences + 1) |occurrence| try h.run(std.testing.allocator, .{ .count = 31, .failure = .{ .stage = stage, .occurrence = occurrence } });
}

test "subject failure stops exactly at each invocation and recovers" {
    try failures(.subject);
}

test "pattern failure stops before amount and recovers" {
    try failures(.pattern);
}

test "amount failure stops before later subjects and recovers" {
    try failures(.amount);
}

test "selected zero arm suppresses failing pattern" {
    try h.run(std.testing.allocator, .{ .count = 32, .zeros = true, .failure = .{ .stage = .pattern } });
}

test "selected zero arm suppresses failing update value" {
    try h.run(std.testing.allocator, .{ .count = 32, .zeros = true, .failure = .{ .stage = .amount } });
}

test "subject error and recovery release failed allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 31, .failure = .{ .stage = .subject, .occurrence = 16 } }});
}

test "pattern error and recovery release failed allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 31, .failure = .{ .stage = .pattern, .occurrence = 7 } }});
}

test "amount error and recovery release failed allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, h.run, .{h.Case{ .count = 31, .failure = .{ .stage = .amount, .occurrence = 7 } }});
}
