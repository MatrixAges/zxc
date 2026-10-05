const std = @import("std");
const program = @import("program");
const mode = @import("options").mode;
const Input = std.meta.Child(program.Input);
const State = std.meta.Child(@FieldType(Input, "seed"));

pub const Case = struct { count: usize, zeros: bool = false, optional: ?u64 = null, bounded: bool = false, forbid_resize: bool = false };

pub fn run(gpa: std.mem.Allocator, case: Case) !void {
    const steps = try std.testing.allocator.alloc(u64, case.count);

    defer std.testing.allocator.free(steps);

    for (steps, 0..) |*item, index| item.* = if (case.zeros) 0 else @intCast(index % 7);

    const initial: State = .{ .count = 3, .total = 10, .last = 2, .flag = true, .optional = case.optional };
    var seed = initial;
    var expected = initial;

    for (steps) |item| {
        if (comptime std.mem.eql(u8, mode, "conditional")) {
            if (item == 0) continue;
        }

        expected.last = expected.count;
        expected.total += expected.count;

        if (comptime !std.mem.eql(u8, mode, "direct")) expected.total += item;
        if (expected.optional == null) expected.optional = expected.count;

        expected.count += 1;
        expected.flag = !expected.flag;
    }

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .seed = &seed, .steps = steps });

    try std.testing.expectEqualDeep(initial, seed);
    for (steps, 0..) |item, index| try std.testing.expectEqual(if (case.zeros) @as(u64, 0) else @as(u64, @intCast(index % 7)), item);

    const result = try executed;

    try std.testing.expectEqualDeep(expected, result.*);

    if (case.count == 0) try std.testing.expect(result == &seed);

    if (case.bounded) {
        errdefer std.debug.print("{s} count={d} capacity={d} bytes={d} allocations={d}\n", .{ mode, case.count, arena.queryCapacity(), tracked.allocated_bytes, tracked.allocations });

        try std.testing.expect(arena.queryCapacity() <= 4096);
        try std.testing.expect(tracked.allocated_bytes <= 4096);
        try std.testing.expect(tracked.allocations <= 4);
    }
}
