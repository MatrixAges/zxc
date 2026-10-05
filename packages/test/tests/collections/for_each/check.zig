const std = @import("std");
const program = @import("program");
pub const mode = @import("options").mode;
pub const Case = struct { count: usize, empty_row: ?usize = null, forbid_allocations: bool = false };

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn run(allocator: std.mem.Allocator, case: Case) !void {
    const values = try std.testing.allocator.alloc(u64, case.count);

    defer std.testing.allocator.free(values);

    for (values, 0..) |*value, index| value.* = @intCast(index % 7);

    var limited = std.testing.FailingAllocator.init(allocator, .{ .fail_index = if (case.forbid_allocations) 0 else std.math.maxInt(usize) });
    var arena = std.heap.ArenaAllocator.init(limited.allocator());

    defer arena.deinit();

    if (comptime isMode("rows")) {
        const rows = try std.testing.allocator.alloc(std.meta.Elem(program.Input), case.count);

        defer std.testing.allocator.free(rows);

        for (rows, 0..) |*row, index| row.* = if (case.empty_row == index) &.{} else values[index .. index + 1];

        const actual = program.execute(&arena, rows);

        for (rows, 0..) |row, index| try std.testing.expectEqualSlices(u64, if (case.empty_row == index) &.{} else values[index .. index + 1], row);
        if (case.empty_row != null and case.empty_row.? < case.count) try std.testing.expectError(error.IndexOutOfBounds, actual) else try std.testing.expectEqual(@as(u64, @intCast(case.count)), try actual);
    } else {
        const actual = program.execute(&arena, values);

        if (comptime isMode("owned")) {
            const output = try actual;

            try std.testing.expectEqual(case.count, output.len);
            for (output, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast((case.count - index - 1) % 7)), value);
        } else try std.testing.expectEqual(@as(u64, @intCast(case.count)), try actual);
    }

    for (values, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index % 7)), value);

    if (case.forbid_allocations) {
        try std.testing.expectEqual(@as(usize, 0), arena.queryCapacity());
        try std.testing.expectEqual(@as(usize, 0), limited.allocations);
        try std.testing.expect(!limited.has_induced_failure);
    }
}
