const std = @import("std");
const program = @import("program");
pub const oracle = @import("oracle.zig");

pub const Case = struct {
    count: u64 = 3,
    left_length: usize = 17,
    right_length: usize = 17,
    delta: i64 = 1,
    enabled: bool = true,
    left_index: u64 = 0,
    right_index: u64 = 0,
    retain: bool = false,
    forbid_resize: bool = false,
};

pub const Stats = struct { bytes: usize, allocations: usize };

pub fn run(memory: std.mem.Allocator, args: Case) !Stats {
    const left = try std.testing.allocator.alloc(i64, args.left_length + 2);

    defer std.testing.allocator.free(left);

    const right = try std.testing.allocator.alloc(i64, args.right_length + 2);

    defer std.testing.allocator.free(right);
    initialize(left, false);
    initialize(right, true);

    const input: oracle.Input = .{
        .left = left[1..][0..args.left_length],
        .right = right[1..][0..args.right_length],
        .count = args.count,
        .delta = args.delta,
        .enabled = args.enabled,
        .left_index = args.left_index,
        .right_index = args.right_index,
        .marker = 913,
    };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = if (args.forbid_resize) 0 else std.math.maxInt(usize) });
    const result = execute(tracked.allocator(), &input, args.retain);

    try unchanged(left, false);
    try unchanged(right, true);

    try std.testing.expectEqualDeep(input, oracle.Input{
        .left = left[1..][0..args.left_length], .right = right[1..][0..args.right_length],
        .count = args.count, .delta = args.delta, .enabled = args.enabled,
        .left_index = args.left_index, .right_index = args.right_index, .marker = 913,
    });

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);
    try result;

    return .{ .bytes = tracked.allocated_bytes, .allocations = tracked.allocations };
}

fn execute(memory: std.mem.Allocator, input: *const oracle.Input, retain: bool) !void {
    var arena = std.heap.ArenaAllocator.init(memory);

    defer arena.deinit();

    const first = program.execute(&arena, input);

    if (oracle.invalid(input)) {
        try std.testing.expectError(error.IndexOutOfBounds, first);

        return;
    }

    const result = try first;

    try oracle.check(result, input);

    if (retain) {
        var next = input.*;

        next.count += 1;
        next.delta -= 1;
        next.marker += 1;
        const later = try program.execute(&arena, &next);

        try oracle.check(result, input);
        try oracle.check(later, &next);
        try oracle.check(result, input);
    }
}

fn initialize(values: []i64, right: bool) void {
    values[0] = -1234567;
    values[values.len - 1] = 7654321;

    for (values[1..][0 .. values.len - 2], 0..) |*value, index| value.* = element(index, right);
}

fn unchanged(values: []const i64, right: bool) !void {
    try std.testing.expectEqual(@as(i64, -1234567), values[0]);
    try std.testing.expectEqual(@as(i64, 7654321), values[values.len - 1]);
    for (values[1..][0 .. values.len - 2], 0..) |value, index| try std.testing.expectEqual(element(index, right), value);
}

fn element(index: usize, right: bool) i64 {
    return if (right) @as(i64, @intCast(index % 17)) + 31 else @as(i64, @intCast(index % 13)) - 5;
}
