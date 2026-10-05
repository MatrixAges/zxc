const std = @import("std");
pub const program = @import("program");
const mode = @import("options").mode;
const Input = std.meta.Child(program.Input);
pub const State = std.meta.Child(@FieldType(Input, "seed"));
pub const Child = std.meta.Child(@FieldType(State, "child"));
pub const labels = [_][]const u8{ "first", "中文" };
pub const Case = struct { count: usize, zeros: bool = false, bound: bool = false, forbid_resize: bool = false };

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn seed(child: *const Child, values: []const []const u8) State {
    return .{ .count = 3, .total = 10, .last = 2, .labels = values, .text = "borrowed 🌿", .child = child };
}

pub fn run(gpa: std.mem.Allocator, case: Case) !void {
    const steps = try std.testing.allocator.alloc(u64, case.count);

    defer std.testing.allocator.free(steps);

    for (steps, 0..) |*item, index| item.* = if (case.zeros) 0 else @intCast(index % 7);

    var child: Child = .{ .value = 11 };
    var initial = seed(&child, &labels);
    var expected_count: u64 = initial.count;
    var expected_total: u64 = initial.total;
    var expected_last: u64 = initial.last;
    var expected_child: u64 = child.value;
    var changed = false;

    for (steps) |item| {
        if ((isMode("select") or isMode("nested")) and item == 0) continue;

        expected_last = expected_count;
        expected_total += expected_count + item + (if (isMode("checked")) @as(u64, labels[0].len) else 0);
        expected_count += 1;

        if (isMode("nested_object")) expected_child += item;

        changed = true;
    }

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .seed = &initial, .steps = steps });

    try std.testing.expectEqual(@as(u64, 3), initial.count);
    try std.testing.expectEqual(@as(u64, 10), initial.total);
    try std.testing.expectEqual(@as(u64, 2), initial.last);
    try std.testing.expectEqual(@as(u64, 11), child.value);
    for (steps, 0..) |item, index| try std.testing.expectEqual(if (case.zeros) @as(u64, 0) else @as(u64, @intCast(index % 7)), item);

    const result = try executed;

    try std.testing.expectEqual(expected_count, result.count);
    try std.testing.expectEqual(expected_total, result.total);
    try std.testing.expectEqual(expected_last, result.last);
    try std.testing.expectEqual(expected_child, result.child.value);
    try std.testing.expectEqualStrings(initial.text, result.text);
    try std.testing.expectEqualStrings(labels[0], result.labels[0]);
    try std.testing.expectEqualStrings(labels[1], result.labels[1]);
    try std.testing.expect(result.labels.ptr == initial.labels.ptr);
    try std.testing.expect(result.text.ptr == initial.text.ptr);
    if (!isMode("nested_object") or !changed) try std.testing.expect(result.child == &child);
    if (!isMode("initial_call")) try std.testing.expectEqual(!changed, result == &initial);

    if (case.bound) {
        errdefer std.debug.print("{s} steps={d} capacity={d} allocated={d} allocations={d}\n", .{ mode, case.count, arena.queryCapacity(), tracked.allocated_bytes, tracked.allocations });

        try std.testing.expect(arena.queryCapacity() <= 4096);
        try std.testing.expect(tracked.allocated_bytes <= 4096);
        try std.testing.expect(tracked.allocations <= 4);
    }
}
