const std = @import("std");
pub const program = @import("program");
const mode = @import("options").mode;

pub const Case = struct { count: usize, start: i64 = -5, empty: bool = false, forbid_resize: bool = false };

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn run(allocator: std.mem.Allocator, case: Case) !usize {
    var values = [_]i64{ -4, 2, 0, -4, 9, 2, 0 };
    const input_values = if (case.empty) values[0..0] else &values;
    const input: std.meta.Child(program.Input) = .{ .count = @intCast(case.count), .start = case.start, .values = input_values };
    var tracked = std.testing.FailingAllocator.init(allocator, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const result = program.execute(&arena, &input);

    try std.testing.expectEqual(@as(u64, @intCast(case.count)), input.count);
    try std.testing.expectEqual(case.start, input.start);
    try std.testing.expectEqualSlices(i64, &.{ -4, 2, 0, -4, 9, 2, 0 }, &values);

    const actual = result catch |err| {
        if (comptime isMode("list_alias")) {
            if (case.empty and case.count > 0 and err == error.IndexOutOfBounds) return tracked.allocated_bytes;
        }

        return err;
    };

    if (comptime isMode("list_alias")) try std.testing.expect(!case.empty or case.count == 0);

    var total = case.start;
    var previous = case.start;
    var other: i64 = if (isMode("branch_return")) case.start + 100 else 0;

    for (0..case.count) |index| {
        if (comptime isMode("branch_return")) {
            previous = if (index % 2 == 0) total else other;
            total += 1;
            other += 2;
        } else {
            previous = total;
            total += if (isMode("list_alias")) values[0] + @as(i64, @intCast(index)) else 1;
        }
    }

    try std.testing.expectEqual(case.start, actual.initial);
    try std.testing.expectEqual(total, actual.total);
    try std.testing.expectEqual(previous, actual.previous);
    try std.testing.expectEqual(@as(u64, @intCast(case.count)), actual.steps);
    try std.testing.expectEqual(other, actual.other);
    try std.testing.expectEqual(input_values.len, actual.values.len);

    for (input_values, actual.values, 0..) |original, updated, index| {
        const increment: i64 = if (isMode("list_alias") and index == 0) @intCast(case.count) else 0;

        try std.testing.expectEqual(original + increment, updated);
    }

    if (!isMode("list_alias") or case.count == 0) try std.testing.expectEqual(input_values.ptr, actual.values.ptr);

    return tracked.allocated_bytes;
}

pub fn failures(allocator: std.mem.Allocator, case: Case) !void {
    _ = try run(allocator, case);
}
