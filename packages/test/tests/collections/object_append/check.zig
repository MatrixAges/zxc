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

    const seed: []const u64 = if (case.empty_seed) &.{} else &.{ 71, 83, 97 };
    var expected: std.ArrayList(u64) = .empty;

    defer expected.deinit(std.testing.allocator);

    try expected.appendSlice(std.testing.allocator, seed);

    var count: u64 = 3;
    var previous: u64 = 99;

    for (steps) |item| {
        if (isMode("select") and item == 0) continue;

        count += 1;
        previous = if (isMode("index_read")) expected.items[0] else expected.items.len;

        if (isMode("overwritten")) {
            expected.clearRetainingCapacity();
        } else if (!(isMode("field_select") and item == 0)) {
            try expected.append(std.testing.allocator, item);
            if (isMode("concat")) try expected.append(std.testing.allocator, item + 10);
        }
    }

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .seed = seed, .steps = steps });

    if (!case.empty_seed) try std.testing.expectEqualSlices(u64, &.{ 71, 83, 97 }, seed);
    for (steps, 0..) |item, index| try std.testing.expectEqual(if (case.zeros) @as(u64, 0) else @as(u64, @intCast(index % 7)), item);

    const result = try executed;

    try std.testing.expectEqual(count, result.count);
    try std.testing.expectEqual(previous, result.previous);
    try std.testing.expectEqualSlices(u64, expected.items, result.values);
    if (result.values.len > 0) try std.testing.expect(result.values.ptr != seed.ptr);

    if (case.bounded) {
        const limit = 8192 + (case.count + expected.items.len + seed.len) * 128;

        errdefer std.debug.print("{s} steps={d} capacity={d} allocated={d} limit={d}\n", .{ mode, case.count, arena.queryCapacity(), tracked.allocated_bytes, limit });

        try std.testing.expect(arena.queryCapacity() <= limit);
        try std.testing.expect(tracked.allocated_bytes <= limit);
    }
}
