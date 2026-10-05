const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");

fn check(gpa: std.mem.Allocator, count: usize) !void {
    const input = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(input);

    for (input, 0..) |*item, index| item.* = @intCast(index * 13);

    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();

    const result = try program.execute(&arena, input);

    try std.testing.expectEqual(count, result.len);

    for (result, 0..) |bundle, index| {
        const expected: u64 = @intCast(index * 13);

        try std.testing.expectEqual(expected, bundle.direct.value);
        try std.testing.expectEqual(expected + 1, bundle.optional.?.value);
        try std.testing.expectEqual(@as(usize, 1), bundle.list.len);
        try std.testing.expectEqual(expected + 2, bundle.list[0].value);
        try std.testing.expectEqual(expected + 3, bundle.tuple.@"0".value);
        try std.testing.expectEqual(expected, bundle.tuple.@"1");
        try std.testing.expectEqual(expected, input[index]);

        if (index > 0) {
            try std.testing.expect(result[index - 1].direct != bundle.direct);
            try std.testing.expect(result[index - 1].optional.? != bundle.optional.?);
        }
    }
}

test "escaped arguments and locals survive later calls through every container" {
    for ([_]usize{ 0, 1, 2, 31, 1024 }) |count| try check(std.testing.allocator, count);
}

test "escaped reference containers clean up every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{@as(usize, 31)});
}
