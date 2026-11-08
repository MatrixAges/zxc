const std = @import("std");
const direct = @import("read_direct");
const view = @import("read_view");
const overlap = @import("read_overlap");
const branch = @import("read_branch");
const call = @import("call_overlap");

test "completed data observations release borrowed return buffers" {
    for ([_]u64{ 0, 1, 100, std.math.maxInt(u64) - 1 }) |value| {
        var first_arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer first_arena.deinit();

        var second_arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer second_arena.deinit();

        var first = std.testing.FailingAllocator.init(first_arena.allocator(), .{});
        var second = std.testing.FailingAllocator.init(second_arena.allocator(), .{});
        const expected = try direct.executeState(first.allocator(), value);
        const actual = try view.executeState(second.allocator(), value);

        try std.testing.expectEqualSlices(u64, &.{ value + 1, value, value }, actual.items);
        try std.testing.expectEqualSlices(u64, expected.items, actual.items);
        try std.testing.expectEqual(first.alloc_index, second.alloc_index);
        try std.testing.expectEqual(first.allocated_bytes, second.allocated_bytes);
        if (value == 0) std.debug.print("loan data read: direct {d}/{d} bytes, view {d}/{d} bytes\n", .{ first.alloc_index, first.allocated_bytes, second.alloc_index, second.allocated_bytes });
    }
}

test "index reads finish after index operand evaluation" {
    for ([_]u64{ 0, 1, 100, std.math.maxInt(u64) - 1 }) |value| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        try std.testing.expectEqual(value + 1, try overlap.execute(&arena, value));
    }
}

test "returning branches retain live borrowed observations" {
    for ([_]u64{ 0, 1, 100 }) |value| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const output = try branch.execute(&arena, value);
        const expected = if (value == 0) [_]u64{ 1, 1 } else [_]u64{ value, value + 1 };

        try std.testing.expectEqualSlices(u64, &expected, output);
    }
}

test "return-only calls observe input after all argument operands finish" {
    for ([_]u64{ 0, 1, 100 }) |value| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        try std.testing.expectEqual(@as(u64, 0), try call.execute(&arena, value));
    }
}
