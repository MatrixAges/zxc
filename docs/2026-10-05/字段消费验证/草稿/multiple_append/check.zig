const std = @import("std");
const program = @import("program");
const mode = @import("options").mode;
pub const Case = struct { count: usize, empty_seed: bool = false, zeros: bool = false, bounded: bool = false, forbid_resize: bool = false };

fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn run(gpa: std.mem.Allocator, case: Case) !void {
    const steps = try std.testing.allocator.alloc(u64, case.count);

    defer std.testing.allocator.free(steps);

    for (steps, 0..) |*item, index| item.* = if (case.zeros) 0 else @intCast(index % 7);

    const first: []const u64 = if (case.empty_seed) &.{} else &.{ 71, 83 };
    const second: []const u64 = if (case.empty_seed) &.{} else &.{ 97, 103, 109 };
    var primary: std.ArrayList(u64) = .empty;
    var secondary: std.ArrayList(u64) = .empty;

    defer primary.deinit(std.testing.allocator);
    defer secondary.deinit(std.testing.allocator);

    try primary.appendSlice(std.testing.allocator, first);
    try secondary.appendSlice(std.testing.allocator, second);

    var total: u64 = 7;

    for (steps) |item| {
        if (isMode("select") and item == 0) continue;

        total += primary.items.len + secondary.items.len;

        if (!isMode("independent") or item % 2 != 0) try primary.append(std.testing.allocator, item);
        if (!isMode("independent") or item % 3 != 0) try secondary.appendSlice(std.testing.allocator, &.{ item, item + 10 });
    }

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .first = first, .second = second, .steps = steps });

    if (!case.empty_seed) {
        try std.testing.expectEqualSlices(u64, &.{ 71, 83 }, first);
        try std.testing.expectEqualSlices(u64, &.{ 97, 103, 109 }, second);
    }

    for (steps, 0..) |item, index| try std.testing.expectEqual(if (case.zeros) @as(u64, 0) else @as(u64, @intCast(index % 7)), item);

    const result = try executed;

    try std.testing.expectEqual(total, result.total);
    try std.testing.expectEqualSlices(u64, primary.items, result.primary);
    try std.testing.expectEqualSlices(u64, secondary.items, result.secondary);

    if (result.primary.len > 0 and result.secondary.len > 0) {
        const primary_start = @intFromPtr(result.primary.ptr);
        const secondary_start = @intFromPtr(result.secondary.ptr);

        try std.testing.expect(primary_start + result.primary.len * @sizeOf(u64) <= secondary_start or secondary_start + result.secondary.len * @sizeOf(u64) <= primary_start);
    }

    if (case.bounded) {
        const skipped = case.zeros and (isMode("select") or isMode("independent"));
        const limit = if (skipped) 4096 else 16384 + 128 * (case.count + primary.items.len + secondary.items.len);

        errdefer std.debug.print("{s} steps={d} capacity={d} allocated={d} limit={d}\n", .{ mode, case.count, arena.queryCapacity(), tracked.allocated_bytes, limit });

        try std.testing.expect(arena.queryCapacity() <= limit);
        try std.testing.expect(tracked.allocated_bytes <= limit);
    }
}
