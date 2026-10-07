const std = @import("std");
const fixture = @import("fixture.zig");
const execution = @import("execution.zig");
const host = @import("host").Impl;
const allocation_testing = @import("allocation_testing");

test "borrowed payload variants preserve values and caller storage" {
    for (0..fixture.count) |variant| try execution.run(std.testing.allocator, .{ .count = 3, .variant = variant });
}

test "empty reduce does not call the native host" {
    for (0..fixture.count) |variant| try execution.run(std.testing.allocator, .{ .count = 0, .variant = variant, .seed_count = 17 });
}

test "borrowed payload calls preserve every seed and dynamic step" {
    for ([_]usize{ 1, 2, 17, 257 }) |count| try execution.run(std.testing.allocator, .{ .count = count, .seed_count = 17 });
}

test "later calls preserve the earlier product and appended scores" {
    for (0..fixture.count) |variant| try execution.run(std.testing.allocator, .{ .count = 17, .seed_count = 3, .variant = variant, .repeat = true });
}

test "borrowed payload growth preserves values through repeated execution" {
    for ([_]usize{ 1024, 4096 }) |count| try execution.run(std.testing.allocator, .{ .count = count, .seed_count = 17, .repeat = true });
}

test "native failure stops at each call in the first and retained later execution" {
    for (1..29) |failure| try std.testing.expectError(error.NativeFailure, execution.run(std.testing.allocator, .{ .count = 3, .repeat = true, .failure = failure }));
}

test "generated and native allocation failures preserve caller storage" {
    host.oom_failures = 0;

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execution.run, .{execution.Case{ .count = 5, .seed_count = 17 }});
    try std.testing.expect(host.oom_failures > 0);
}

test "later allocation failures preserve the first escaped result" {
    host.oom_failures = 0;

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execution.run, .{execution.Case{ .count = 3, .seed_count = 3, .repeat = true }});
    try std.testing.expect(host.oom_failures > 0);
}
