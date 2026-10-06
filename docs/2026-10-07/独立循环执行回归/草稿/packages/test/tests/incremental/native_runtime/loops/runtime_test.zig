const std = @import("std");
const program = @import("program");
const host = @import("host");
const allocation_testing = @import("allocation_testing");
const Input = std.meta.Child(program.Input);
const normal: Input = .{ .count = 3, .nested = false, .post = false, .enabled = true };
const one: Input = .{ .count = 1, .nested = false, .post = false, .enabled = true };
const normal_trace = [_]u64{ 1003, 2003, 3003, 2002, 3002, 2001, 3001, 2000, 4000, 6003, 6002, 6001, 7000 };
const one_trace = [_]u64{ 1001, 2001, 3001, 2000, 4000, 6001, 7000 };

fn check(input: Input, expected: []const u64, failure: usize) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();
    host.reset(failure);

    if (failure == 0) {
        try std.testing.expectEqual(input.count, try program.execute(&arena, &input));
    } else {
        try std.testing.expectError(error.Stop, program.execute(&arena, &input));
    }

    try std.testing.expectEqualSlices(u64, expected, host.trace[0..host.calls]);
}

test "discarded precondition loop retains initial condition and step order" {
    try check(normal, &normal_trace, 0);
}

test "false initial condition still evaluates initial and condition once" {
    try check(.{ .count = 0, .nested = false, .post = false, .enabled = true }, &.{ 1000, 2000, 4000, 7000 }, 0);
}

test "postcondition zero state runs its body before false condition" {
    try check(.{ .count = 0, .nested = false, .post = true, .enabled = true }, &.{ 1000, 3000, 2000, 4000, 7000 }, 0);
}

test "postcondition multiple steps use updated state in each condition" {
    try check(.{ .count = 3, .nested = false, .post = true, .enabled = true }, &.{ 1003, 3003, 2002, 3002, 2001, 3001, 2000, 4000, 6003, 6002, 6001, 7000 }, 0);
}

test "unselected branch suppresses initial condition and loop effects" {
    try check(.{ .count = 1, .nested = true, .post = false, .enabled = false }, &.{ 4000, 6001, 7000 }, 0);
}

test "nested discarded loop keeps inner and outer states separate" {
    try check(.{ .count = 2, .nested = true, .post = false, .enabled = true }, &.{ 1002, 2002, 3002, 5022, 5021, 2001, 3001, 5012, 5011, 2000, 4000, 6002, 6001, 7000 }, 0);
}

test "initial native failure stops before first condition" {
    try check(one, one_trace[0..1], 1);
}

test "first condition failure stops before body" {
    try check(one, one_trace[0..2], 2);
}

test "step failure stops before update and next condition" {
    try check(one, one_trace[0..3], 3);
}

test "final condition failure prevents following statements" {
    try check(one, one_trace[0..4], 4);
}

test "after loop failure prevents helper module execution" {
    try check(one, one_trace[0..5], 5);
}

test "helper discarded loop failure propagates across module boundary" {
    try check(one, one_trace[0..6], 6);
}

test "final native failure survives completed standalone loops" {
    try check(one, &one_trace, 7);
}

test "inner native failure prevents both loops from advancing" {
    try check(.{ .count = 2, .nested = true, .post = false, .enabled = true }, &.{ 1002, 2002, 3002, 5022 }, 4);
}

fn execute(allocator: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const input: Input = .{ .count = 2, .nested = true, .post = false, .enabled = true };
    const expected = [_]u64{ 1002, 2002, 3002, 5022, 5021, 2001, 3001, 5012, 5011, 2000, 4000, 6002, 6001, 7000 };

    host.reset(0);

    const output = program.execute(&arena, &input) catch |err| {
        try std.testing.expect(host.calls <= expected.len);
        try std.testing.expectEqualSlices(u64, expected[0..host.calls], host.trace[0..host.calls]);

        return err;
    };

    try std.testing.expectEqual(input.count, output);
    try std.testing.expectEqualSlices(u64, &expected, host.trace[0..host.calls]);
}

test "allocation failure keeps a valid native trace prefix without leaks" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, execute, .{});
}
