const std = @import("std");
const program = @import("program");
const allocation_testing = @import("allocation_testing");
const mode = @import("options").mode;

fn cell(value: anytype) !program.Cell {
    if (comptime std.mem.eql(u8, mode, "escape_optional")) {
        try std.testing.expect(value != null);

        return value.?;
    }

    if (comptime std.mem.eql(u8, mode, "escape_list")) {
        try std.testing.expectEqual(@as(usize, 1), value.len);

        return value[0];
    }

    if (comptime std.mem.eql(u8, mode, "escape_tuple")) {
        try std.testing.expectEqual(value.@"0", value.@"1".value);

        return value.@"1";
    }

    return value.inner.cell;
}

fn check(gpa: std.mem.Allocator, count: usize) !void {
    const input = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(input);

    for (input, 0..) |*item, index| item.* = @intCast(index * 17);

    var arena = std.heap.ArenaAllocator.init(gpa);

    defer arena.deinit();

    const result = try program.execute(&arena, input);

    try std.testing.expectEqual(count, result.len);

    for (result, 0..) |bundle, index| {
        const expected: u64 = @intCast(index * 17);
        const argument = try cell(bundle.argument);
        const local = try cell(bundle.local);

        try std.testing.expectEqual(expected, argument.value);
        try std.testing.expectEqual(expected + 1, local.value);
        try std.testing.expect(argument != local);
        try std.testing.expectEqual(expected, input[index]);

        if (index > 0) {
            try std.testing.expect(try cell(result[index - 1].argument) != argument);
            try std.testing.expect(try cell(result[index - 1].local) != local);
        }
    }
}

test "isolated container retains arguments and locals after all calls return" {
    for ([_]usize{ 0, 1, 2, 31, 1024 }) |count| try check(std.testing.allocator, count);
}

test "isolated container releases every failed allocation" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, check, .{@as(usize, 31)});
}
