const std = @import("std");
const direct = @import("direct");
const dead = @import("dead");
const live = @import("live_view");

comptime {
    _ = @import("fresh_append_test.zig");
    _ = @import("read_test.zig");
}

test "metadata-only views preserve values without retaining source storage" {
    for ([_]u64{ 0, 1, 100, std.math.maxInt(u64) }) |value| {
        var direct_buffer: [8192]u8 = undefined;
        var direct_memory = std.heap.FixedBufferAllocator.init(&direct_buffer);
        var direct_counter = std.testing.FailingAllocator.init(direct_memory.allocator(), .{});
        const first = try direct.executeState(direct_counter.allocator(), value);
        var dead_buffer: [8192]u8 = undefined;
        var dead_memory = std.heap.FixedBufferAllocator.init(&dead_buffer);
        var dead_counter = std.testing.FailingAllocator.init(dead_memory.allocator(), .{});
        const second = try dead.executeState(dead_counter.allocator(), value);

        try std.testing.expectEqualSlices(u64, &.{ value, 1 }, first.items);
        try std.testing.expectEqualSlices(u64, first.items, second.items);
        try std.testing.expectEqual(direct_counter.alloc_index, dead_counter.alloc_index);
        try std.testing.expectEqual(direct_counter.allocated_bytes, dead_counter.allocated_bytes);
        if (value == 0) std.debug.print("loan allocations: direct {d}/{d} bytes, metadata view {d}/{d} bytes\n", .{ direct_counter.alloc_index, direct_counter.allocated_bytes, dead_counter.alloc_index, dead_counter.allocated_bytes });
    }
}

test "data reads through a live view retain the original source values" {
    for ([_]u64{ 0, 1, 100, std.math.maxInt(u64) - 1 }) |value| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        const output = try live.execute(&arena, value);

        try std.testing.expectEqualSlices(u64, &.{ value + 1, value }, output);
    }
}
