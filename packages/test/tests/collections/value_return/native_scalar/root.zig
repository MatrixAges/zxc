const std = @import("std");
const program = @import("program");
const host = @import("native_scalar");
const allocation_testing = @import("allocation_testing");
const Input = std.meta.Child(program.Input);
const State = std.meta.Child(@FieldType(Input, "first"));
const Case = struct { count: usize, failure: usize = 0, repeat: bool = false };

fn expected(initial: State) State {
    var state = initial;

    for (initial.steps[initial.index..]) |value| {
        state.total += value;
        state.last = value;
        state.index += 1;
    }

    return state;
}

fn expectState(initial: State, result: *const State) !void {
    try std.testing.expectEqualDeep(expected(initial), result.*);
    try std.testing.expectEqual(initial.steps.ptr, result.steps.ptr);
}

fn preserved(first: State, second: State, steps: [2][]const u64) !void {
    try std.testing.expectEqual(steps[0].ptr, first.steps.ptr);
    try std.testing.expectEqual(steps[0].len, first.steps.len);
    try std.testing.expectEqual(steps[1].ptr, second.steps.ptr);
    try std.testing.expectEqual(steps[1].len, second.steps.len);
    try std.testing.expectEqual(@as(u64, 0), first.index);
    try std.testing.expectEqual(@as(u64, 7), first.total);
    try std.testing.expectEqual(@as(u64, 9), first.last);
    try std.testing.expectEqual(@as(u64, 0), second.index);
    try std.testing.expectEqual(@as(u64, 1007), second.total);
    try std.testing.expectEqual(@as(u64, 1009), second.last);
    for (first.steps, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index * 17)), value);
    for (second.steps, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index * 17 + 1)), value);
}

fn trace(expected_events: []const host.Event) !void {
    try std.testing.expect(host.calls <= expected_events.len);
    try std.testing.expectEqualDeep(expected_events[0..host.calls], host.events[0..host.calls]);
}

fn run(gpa: std.mem.Allocator, case: Case) !void {
    const first_steps = try std.testing.allocator.alloc(u64, case.count);

    defer std.testing.allocator.free(first_steps);

    const second_steps = try std.testing.allocator.alloc(u64, case.count);

    defer std.testing.allocator.free(second_steps);

    for (first_steps, 0..) |*value, index| value.* = @intCast(index * 17);
    for (second_steps, 0..) |*value, index| value.* = @intCast(index * 17 + 1);

    const expected_events = try std.testing.allocator.alloc(host.Event, case.count * 6);

    defer std.testing.allocator.free(expected_events);

    var event_index: usize = 0;

    for ([_][]const u64{ first_steps, second_steps }) |steps| {
        for (steps) |value| {
            for (1..4) |marker| {
                expected_events[event_index] = .{ .marker = @intCast(marker), .value = value };
                event_index += 1;
            }
        }
    }

    var first: State = .{ .index = 0, .total = 7, .last = 9, .steps = first_steps };
    var second: State = .{ .index = 0, .total = 1007, .last = 1009, .steps = second_steps };
    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();
    host.reset(case.failure);

    const executed = program.execute(&arena, &.{ .first = &first, .second = &second });

    try preserved(first, second, .{ first_steps, second_steps });
    try trace(expected_events);
    if (host.oom_calls) |calls| try std.testing.expectEqual(calls, host.calls);
    if (case.failure != 0) try std.testing.expectEqual(case.failure, host.calls);

    const result = try executed;

    try std.testing.expectEqual(expected_events.len, host.calls);
    try expectState(first, result.first);
    try expectState(second, result.second);
    try std.testing.expect(result.first != result.second);

    if (case.count == 0) {
        try std.testing.expect(result.first == &first);
        try std.testing.expect(result.second == &second);
    }

    if (case.repeat) {
        var later_first = first;
        var later_second = second;
        later_first.total += 2048;
        later_second.total += 4096;

        host.reset(0);

        const later_executed = program.execute(&arena, &.{ .first = &later_first, .second = &later_second });

        try preserved(first, second, .{ first_steps, second_steps });
        try std.testing.expectEqual(first_steps.ptr, later_first.steps.ptr);
        try std.testing.expectEqual(first_steps.len, later_first.steps.len);
        try std.testing.expectEqual(second_steps.ptr, later_second.steps.ptr);
        try std.testing.expectEqual(second_steps.len, later_second.steps.len);

        const later = try later_executed;

        try std.testing.expectEqual(expected_events.len, host.calls);
        try trace(expected_events);
        try expectState(later_first, later.first);
        try expectState(later_second, later.second);
        try expectState(first, result.first);
        try expectState(second, result.second);
        try std.testing.expect(result.first != later.first);
        try std.testing.expect(result.second != later.second);
        try preserved(first, second, .{ first_steps, second_steps });
    }
}

test "scalar native object loops preserve every call and both escaped results" {
    for ([_]usize{ 0, 1, 2, 31 }) |count| try run(std.testing.allocator, .{ .count = count, .repeat = true });
}

test "scalar native object loops stop at every first failure before later calls" {
    for (1..19) |failure| try std.testing.expectError(error.NativeFailure, run(std.testing.allocator, .{ .count = 3, .failure = failure }));
}

test "scalar native object loops release every failed allocation and preserve inputs" {
    host.oom_failures = 0;

    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, run, .{Case{ .count = 5 }});
    try std.testing.expect(host.oom_failures > 0);
}
