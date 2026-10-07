const std = @import("std");
const program = @import("program");
const mode = @import("options").mode;
pub const Case = struct { count: usize, length: usize, forbid_resize: bool = false };
pub const Stats = struct { bytes: usize, allocations: usize };

pub fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn run(gpa: std.mem.Allocator, case: Case) !Stats {
    const values = try std.testing.allocator.alloc(u64, case.length);

    defer std.testing.allocator.free(values);

    for (values, 0..) |*value, index| value.* = @intCast(index + 1);

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });

    const length = if (isMode("filter")) case.length / 2 else case.length;

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const executed = program.execute(&arena, &.{ .values = values, .count = @intCast(case.count) });

        for (values, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index + 1)), value);

        const result = executed catch |err| block: {
            if (err == error.OutOfMemory) return err;

            try std.testing.expect(length == 0 and case.count != 0);
            try std.testing.expectEqual(error.IndexOutOfBounds, err);

            break :block null;
        };

        if (result) |output| {
            try std.testing.expect(length != 0 or case.count == 0);
            try std.testing.expectEqual(case.length, output.original.len);
            try std.testing.expectEqual(length, output.values.len);
            for (output.original, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index + (if (isMode("shared")) @as(usize, 2) else 1))), value);

            for (output.values, 0..) |value, index| {
                const initial: u64 = if (isMode("filter")) @intCast((index + 1) * 2) else @intCast(index + (if (isMode("borrowed") or (isMode("repeated") and case.count == 0)) @as(usize, 1) else 2));
                const increment: u64 = if (index != 0) 0 else if (isMode("repeated")) (if (case.count == 0) @as(u64, 0) else 3) else @intCast(case.count);

                try std.testing.expectEqual(initial + increment, value);
            }

            if (!isMode("shared")) try std.testing.expect(output.original.ptr == values.ptr);

            if (length > 0) {
                if (isMode("shared")) {
                    try std.testing.expect(output.original.ptr != values.ptr);
                    try std.testing.expectEqual(case.count == 0, output.values.ptr == output.original.ptr);
                } else {
                    try std.testing.expectEqual((isMode("borrowed") or isMode("repeated")) and case.count == 0, output.values.ptr == values.ptr);
                }
            }
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);

    return .{ .bytes = tracked.allocated_bytes, .allocations = tracked.allocations };
}

pub fn failures(gpa: std.mem.Allocator) !void {
    _ = try run(gpa, .{ .count = 3, .length = 17 });
}
