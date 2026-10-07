const std = @import("std");
const program = @import("program");
const host = @import("host");
const expected = @import("expected.zig");
const Input = std.meta.Child(program.Input);
const State = std.meta.Child(@FieldType(Input, "seed"));
pub const Case = struct { count: usize, zeros: bool = false, failure: host.Failure = .{}, bound: bool = false, forbid_resize: bool = false };

fn execute(arena: *std.heap.ArenaAllocator, seed: *const State, steps: []const u64, failure: host.Failure) !void {
    var model = try expected.make(steps, failure);

    defer model.deinit();
    host.reset(failure);

    const result = program.execute(arena, &.{ .seed = seed, .steps = steps }) catch |err| block: {
        if (err == error.OutOfMemory) return err;

        try std.testing.expect(model.failure != null);
        try std.testing.expectEqual(model.failure.?, err);

        break :block null;
    };

    try std.testing.expectEqual(model.events.items.len, host.calls);

    for (model.events.items, host.trace[0..host.calls]) |wanted, actual| {
        try std.testing.expectEqual(wanted.stage, actual.stage);
        try std.testing.expectEqual(wanted.value, actual.value);
    }

    if (model.failure != null) {
        try std.testing.expect(result == null);

        return;
    }

    const output = result.?;

    try std.testing.expectEqual(model.count, output.count);
    try std.testing.expectEqual(model.total, output.total);
    try std.testing.expectEqualStrings(seed.text, output.text);
    try std.testing.expect(output.text.ptr == seed.text.ptr);
    try std.testing.expectEqual(model.count == 3, output == seed);
}

pub fn run(gpa: std.mem.Allocator, case: Case) !void {
    const steps = try std.testing.allocator.alloc(u64, case.count);

    defer std.testing.allocator.free(steps);

    for (steps, 0..) |*item, index| item.* = if (case.zeros) 0 else @intCast(index % 7);

    var seed: State = .{ .count = 3, .total = 10, .text = "borrowed 🌿" };
    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    try execute(&arena, &seed, steps, case.failure);
    if (case.failure.stage != null) try execute(&arena, &seed, steps, .{});
    try std.testing.expectEqual(@as(u64, 3), seed.count);
    try std.testing.expectEqual(@as(u64, 10), seed.total);
    try std.testing.expectEqualStrings("borrowed 🌿", seed.text);
    for (steps, 0..) |item, index| try std.testing.expectEqual(if (case.zeros) @as(u64, 0) else @as(u64, @intCast(index % 7)), item);

    if (case.bound) {
        errdefer std.debug.print("effectful match steps={d} capacity={d} allocated={d} allocations={d}\n", .{ case.count, arena.queryCapacity(), tracked.allocated_bytes, tracked.allocations });

        try std.testing.expect(arena.queryCapacity() <= 4096);
        try std.testing.expect(tracked.allocated_bytes <= 4096);
        try std.testing.expect(tracked.allocations <= 4);
    }
}
