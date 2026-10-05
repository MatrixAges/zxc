const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");

fn check(gpa: std.mem.Allocator, count: usize) !void {
    var a = [_]u64{ 71, 83 };
    var b = [_]u64{ 97, 101 };
    const steps = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(steps);

    for (steps, 0..) |*item, index| item.* = @intCast(index % 7);

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    const executed = program.execute(&arena, &.{ .a = &a, .b = &b, .steps = steps });

    try std.testing.expectEqualSlices(u64, &.{ 71, 83 }, &a);
    try std.testing.expectEqualSlices(u64, &.{ 97, 101 }, &b);
    for (steps, 0..) |item, index| try std.testing.expectEqual(@as(u64, @intCast(index % 7)), item);

    const result = try executed;

    try std.testing.expectEqual(@as(u64, @intCast(count + 3)), result.count);
    try std.testing.expectEqual(@as(u64, if (count == 0) 0 else 71), result.seen);
    try std.testing.expect(result.a.ptr == &a);
    try std.testing.expectEqualSlices(u64, &a, result.a);
    try std.testing.expectEqual(count == 0, result.b.ptr == &b);
    try std.testing.expectEqual(b.len + count, result.b.len);
    try std.testing.expectEqualSlices(u64, &b, result.b[0..b.len]);
    try std.testing.expectEqualSlices(u64, steps, result.b[b.len..]);

    const limit = 8192 + (count + result.b.len) * 128;

    try std.testing.expect(arena.queryCapacity() <= limit);
    try std.testing.expect(tracked.allocated_bytes <= limit);
}

fn recover(gpa: std.mem.Allocator) !void {
    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();

    var b = [_]u64{ 97, 101 };
    var steps = [_]u64{ 2, 3 };
    const failed = program.execute(&arena, &.{ .a = &.{}, .b = &b, .steps = &steps });

    if (failed) |_| return error.ExpectedIndexFailure else |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(error.IndexOutOfBounds, err);
    }

    try std.testing.expectEqualSlices(u64, &.{ 97, 101 }, &b);
    try std.testing.expectEqualSlices(u64, &.{ 2, 3 }, &steps);

    var a = [_]u64{71};
    const result = try program.execute(&arena, &.{ .a = &a, .b = &b, .steps = &steps });

    try std.testing.expectEqualSlices(u64, &.{ 97, 101, 2, 3 }, result.b);
    try std.testing.expectEqual(@as(u64, 71), result.seen);
    try std.testing.expectEqual(@as(u64, 5), result.count);
}

test "rejected first lane coexists with buffered second lane" {
    for ([_]usize{ 0, 1, 2, 37, 8192 }) |count| try check(std.testing.allocator, count);
}

test "mixed lane execution cleans every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{@as(usize, 37)});
}

test "mixed lane index failure permits recovery in the same arena" {
    try recover(std.testing.allocator);
}

test "mixed lane failure and recovery clean every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, recover, .{});
}
