const std = @import("std");
const program = @import("program");

test "owned primitive map reverse avoids a second complete payload buffer" {
    for ([_]usize{ 2048, 16384 }) |count| {
        const input = try std.testing.allocator.alloc(i64, count);

        defer std.testing.allocator.free(input);

        for (input, 0..) |*item, index| item.* = @intCast(index);

        var tracked = std.testing.FailingAllocator.init(std.testing.allocator, .{});

        {
            var arena = std.heap.ArenaAllocator.init(tracked.allocator());

            defer arena.deinit();

            const output = try program.execute(&arena, input);

            try std.testing.expectEqualSlices(i64, input, output.original);
            try std.testing.expectEqual(count, output.reversed.len);

            for (input, output.reversed, 0..) |item, reversed, index| {
                try std.testing.expectEqual(@as(i64, @intCast(index)), item);
                try std.testing.expectEqual(@as(i64, @intCast(count - index)), reversed);
            }

            const payload = count * @sizeOf(i64);

            std.debug.print("owned reverse count={d} allocated={d} capacity={d} payload={d}\n", .{ count, tracked.allocated_bytes, arena.queryCapacity(), payload });

            try std.testing.expect(tracked.allocated_bytes < payload * 2);
        }

        try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);
    }
}
