const std = @import("std");
pub const program = @import("program");
const mode = @import("options").mode;

pub const Case = struct {
    outer: usize = 2,
    inner: usize = 3,
    length: usize = 17,
    selected: usize = 0,
    delta: i64 = 1,
    enabled: bool = true,
    forbid_resize: bool = false,
};

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn run(memory: std.mem.Allocator, case: Case) !usize {
    const storage = try std.testing.allocator.alloc(i64, case.length + 2);

    defer std.testing.allocator.free(storage);

    storage[0] = -1234567;
    storage[storage.len - 1] = 7654321;

    for (storage[1..][0..case.length], 0..) |*value, index| value.* = @as(i64, @intCast(index % 13)) - 5;

    const snapshot = try std.testing.allocator.dupe(i64, storage);

    defer std.testing.allocator.free(snapshot);

    const input: std.meta.Child(program.Input) = .{
        .values = storage[1..][0..case.length],
        .outer = @intCast(case.outer),
        .inner = @intCast(case.inner),
        .selected = @intCast(case.selected),
        .delta = case.delta,
        .enabled = case.enabled,
    };

    var tracked = std.testing.FailingAllocator.init(memory, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const result = program.execute(&arena, &input);

    try std.testing.expectEqualSlices(i64, snapshot, storage);
    try std.testing.expectEqual(@as(u64, @intCast(case.outer)), input.outer);
    try std.testing.expectEqual(@as(u64, @intCast(case.inner)), input.inner);
    try std.testing.expectEqual(@as(u64, @intCast(case.selected)), input.selected);
    try std.testing.expectEqual(case.delta, input.delta);
    try std.testing.expectEqual(case.enabled, input.enabled);

    const calls: i64 = @intCast(if (isMode("fallback")) 1 else case.outer);
    const rounds: i64 = @intCast(case.inner);
    const updates = calls * rounds * @as(i64, if (isMode("chain")) 2 else if (isMode("branch") and !case.enabled) 0 else 1);
    const invalid = updates > 0 and case.selected >= case.length;

    const actual = result catch |err| {
        if (invalid and err == error.IndexOutOfBounds) return tracked.allocated_bytes;

        return err;
    };

    try std.testing.expect(!invalid);
    try std.testing.expectEqualSlices(i64, input.values, actual.original);
    try std.testing.expectEqual(input.values.ptr, actual.original.ptr);
    try std.testing.expectEqual(case.length, actual.values.len);
    try std.testing.expectEqual(case.length, actual.mirror.len);
    try std.testing.expectEqual(@as(u64, @intCast(if (isMode("fallback")) case.inner else case.outer)), actual.steps);

    const escape = isMode("escape_before") or isMode("escape_after");
    const mirror_updates = if (escape and updates > 0) updates - @as(i64, if (isMode("escape_before")) 1 else 0) else if (isMode("mixed")) updates * 2 else if (isMode("duplicate")) updates else if (isMode("captured") and calls > 0) (calls - 1) * rounds else 0;

    for (input.values, actual.values, actual.mirror, 0..) |original, updated, mirror, index| {
        try std.testing.expectEqual(original + if (index == case.selected) updates * case.delta else 0, updated);
        try std.testing.expectEqual(original + if (index == case.selected) mirror_updates * case.delta else 0, mirror);
    }

    const start: i64 = if (case.selected < case.length) input.values[case.selected] else 0;
    const prior_sum = calls * start + rounds * case.delta * @as(i64, if (isMode("mixed")) 2 else 1) * @divTrunc(calls * (calls - 1), 2);
    const seen = if (escape) updates * start + case.delta * @divTrunc(updates * (updates + @as(i64, if (isMode("escape_after")) 1 else -1)), 2) else if (isMode("captured")) @max(rounds - 1, 0) * prior_sum else if ((isMode("duplicate") or isMode("mixed")) and rounds > 0) prior_sum else 0;

    try std.testing.expectEqual(seen, actual.seen);

    if (isMode("duplicate")) try std.testing.expectEqual(actual.values.ptr, actual.mirror.ptr);

    return tracked.allocated_bytes;
}

pub fn failures(memory: std.mem.Allocator, case: Case) !void {
    _ = try run(memory, case);
}
