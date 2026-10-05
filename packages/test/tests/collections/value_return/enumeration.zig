const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const State = std.meta.Child(@FieldType(std.meta.Child(program.Input), "seed"));
const Phase = @FieldType(State, "phase");

fn check(gpa: std.mem.Allocator, initial: State, count: usize) !void {
    const steps = try std.testing.allocator.alloc(bool, count);

    defer std.testing.allocator.free(steps);

    for (steps, 0..) |*item, index| item.* = index % 3 != 0;

    var seed = initial;
    var expected = initial;

    for (steps) |item| {
        if (expected.saved == null) expected.saved = expected.phase;
        if (item) expected.phase = if (expected.phase == .On) .Off else .On;

        expected.count += 1;
    }

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .seed = &seed, .steps = steps });

    try std.testing.expectEqualDeep(initial, seed);

    for (steps, 0..) |item, index| try std.testing.expectEqual(index % 3 != 0, item);

    const result = try executed;

    try std.testing.expectEqualDeep(expected, result.*);
    if (count == 0) try std.testing.expect(result == &seed);
    try std.testing.expect(arena.queryCapacity() <= 4096);
    try std.testing.expect(tracked.allocated_bytes <= 4096);
    try std.testing.expect(tracked.allocations <= 4);
}

test "flat enum and optional enum preserve all initial states" {
    for ([_]Phase{ .Off, .On }) |phase| {
        for ([_]?Phase{ null, .Off, .On }) |saved| {
            for ([_]usize{ 0, 1, 2, 3, 4, 17 }) |count| try check(std.testing.allocator, .{ .phase = phase, .saved = saved, .count = 2 }, count);
        }
    }
}

test "flat enum return allocation stays bounded without resize" {
    for ([_]usize{ 128, 2048, 16384 }) |count| try check(std.testing.allocator, .{ .phase = .Off, .saved = null, .count = 2 }, count);
}

test "flat enum return frees all failed allocations" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{ State{ .phase = .On, .saved = null, .count = 2 }, @as(usize, 31) });
}
