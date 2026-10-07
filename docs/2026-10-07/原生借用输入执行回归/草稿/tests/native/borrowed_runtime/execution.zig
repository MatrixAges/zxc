const std = @import("std");
const program = @import("program");
const host = @import("host").Impl;
const fixture = @import("fixture.zig");
const Input = std.meta.Child(program.Input);
pub const Case = struct { count: usize, variant: usize = 1, seed_count: usize = 0, failure: usize = 0, repeat: bool = false };

fn trace(first: fixture.Data, second: fixture.Data, first_count: usize, second_count: usize) !void {
    const limit = (first_count + second_count) * 4;

    try std.testing.expect(host.calls <= limit);

    for (host.events[0..host.calls], 0..) |event, index| {
        const data = if (index < first_count * 4) first else second;

        try std.testing.expectEqual(@as(u8, @intCast(index % 4 + 1)), event.marker);
        try std.testing.expectEqual(data.score, event.score);
        try std.testing.expectEqual(data.length, event.length);
        try std.testing.expectEqual(data.present, event.present);
    }

    if (host.oom_calls) |calls| try std.testing.expectEqual(calls, host.calls);
    if (host.failure != 0 and host.calls >= host.failure) try std.testing.expectEqual(host.failure, host.calls);
}

fn preserved(input: Input, before: Input, data: *const fixture.Data, snapshot: fixture.Data, seed: []const u64, steps: []const u64) !void {
    try data.preserved(snapshot);
    try std.testing.expectEqualDeep(before.payload, input.payload);
    try std.testing.expectEqual(before.seed.ptr, input.seed.ptr);
    try std.testing.expectEqual(before.steps.ptr, input.steps.ptr);
    try std.testing.expectEqual(before.seed.len, input.seed.len);
    try std.testing.expectEqual(before.steps.len, input.steps.len);
    for (seed, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index * 7 + 3)), value);
    for (steps, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index % 17)), value);
}

fn result(input: Input, data: fixture.Data, output: program.Output) !void {
    try std.testing.expectEqualDeep(input.payload, output.payload);
    try std.testing.expectEqual(input.seed.len + input.steps.len, output.scores.len);
    try std.testing.expectEqualSlices(u64, input.seed, output.scores[0..input.seed.len]);
    for (input.steps, output.scores[input.seed.len..]) |item, actual| try std.testing.expectEqual(3 * data.score + 8 + item, actual);

    const last = if (input.steps.len == 0) 17 else 3 * data.score + 8 + input.steps[input.steps.len - 1];

    try std.testing.expectEqual(last, output.last);
}

pub fn run(allocator: std.mem.Allocator, case: Case) !void {
    var first_data: fixture.Data = .{};
    var second_data: fixture.Data = .{};
    const payload = first_data.init(case.variant);
    const second_payload = second_data.init((case.variant + 1) % fixture.count);
    const first_snapshot = first_data;
    const second_snapshot = second_data;
    const seed = try std.testing.allocator.alloc(u64, case.seed_count);

    defer std.testing.allocator.free(seed);

    const steps = try std.testing.allocator.alloc(u64, case.count + @intFromBool(case.repeat));

    defer std.testing.allocator.free(steps);

    for (seed, 0..) |*value, index| value.* = @intCast(index * 7 + 3);
    for (steps, 0..) |*value, index| value.* = @intCast(index % 17);

    var input: Input = .{ .payload = payload, .seed = seed, .steps = steps[0..case.count] };
    var second: Input = .{ .payload = second_payload, .seed = seed, .steps = steps };
    const original = input;
    const second_original = second;
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();
    host.reset(case.failure);

    const executed = program.execute(&arena, &input);

    try preserved(input, original, &first_data, first_snapshot, seed, steps);
    try trace(first_data, second_data, case.count, 0);

    const first = try executed;

    try result(input, first_data, first);

    if (case.repeat) {
        const later_executed = program.execute(&arena, &second);

        try preserved(input, original, &first_data, first_snapshot, seed, steps);
        try preserved(second, second_original, &second_data, second_snapshot, seed, steps);
        try result(input, first_data, first);
        try trace(first_data, second_data, case.count, steps.len);

        const later = try later_executed;

        try result(second, second_data, later);
        try result(input, first_data, first);
    }

    try std.testing.expectEqual((case.count + if (case.repeat) steps.len else @as(usize, 0)) * 4, host.calls);
}
