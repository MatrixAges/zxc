const std = @import("std");
const program = @import("program");
const host = @import("origin_host");
const mode = @import("options").mode;
pub const Case = struct { count: usize, length: usize, enabled: bool = true, forbid_resize: bool = false };
pub const Stats = struct { bytes: usize, allocations: usize };

fn isMode(comptime name: []const u8) bool {
    return comptime std.mem.eql(u8, mode, name);
}

pub fn run(gpa: std.mem.Allocator, case: Case) !Stats {
    const values = try std.testing.allocator.alloc(u64, case.length);

    defer std.testing.allocator.free(values);

    for (values, 0..) |*value, index| value.* = @intCast(index + 1);

    host.reset();

    var tracked = std.testing.FailingAllocator.init(gpa, .{ .resize_fail_index = if (case.forbid_resize) 0 else std.math.maxInt(usize) });

    {
        var arena = std.heap.ArenaAllocator.init(tracked.allocator());

        defer arena.deinit();

        const executed = program.execute(&arena, &.{ .values = values, .count = @intCast(case.count), .enabled = case.enabled });

        for (values, 0..) |value, index| try std.testing.expectEqual(@as(u64, @intCast(index + 1)), value);

        const result = executed catch |err| block: {
            if (err == error.OutOfMemory) return err;

            try std.testing.expect(case.length == 0 and case.count != 0);
            try std.testing.expectEqual(error.IndexOutOfBounds, err);

            break :block null;
        };

        if (result) |output| {
            try std.testing.expect(case.length != 0 or case.count == 0);
            try std.testing.expectEqual(case.length, output.original.len);
            try std.testing.expectEqual(case.length, output.values.len);

            const borrowed = isMode("borrowed") or (isMode("mixed") and !case.enabled);
            const offset: u64 = if (borrowed or isMode("literal")) 0 else 1;
            var increment: u64 = @intCast(case.count);
            var expected_trace: u64 = 0;

            if (isMode("impure")) {
                increment = 0;

                for (0..case.count) |index| {
                    increment += @as(u64, @intCast(index % 3 + 1));
                    expected_trace = expected_trace *% 131 +% @as(u64, @intCast(index + 1));
                }
            }

            try std.testing.expectEqual(if (isMode("impure")) @as(u64, @intCast(case.count)) else 0, host.calls);
            try std.testing.expectEqual(expected_trace, host.trace);

            for (output.original, 0..) |value, index| {
                const expected = @as(u64, @intCast(index + 1)) + if (isMode("shared")) @as(u64, 1) else 0;

                try std.testing.expectEqual(expected, value);
            }

            for (output.values, 0..) |value, index| {
                const initial = @as(u64, @intCast(index + 1)) + offset;

                try std.testing.expectEqual(initial + if (index == 0) increment else 0, value);
            }

            if (!isMode("shared")) try std.testing.expectEqual(values.ptr, output.original.ptr);

            if (case.length != 0) {
                if (isMode("shared")) {
                    try std.testing.expect(output.original.ptr != values.ptr);
                    try std.testing.expectEqual(case.count == 0, output.values.ptr == output.original.ptr);
                } else {
                    try std.testing.expectEqual(borrowed and case.count == 0, output.values.ptr == values.ptr);
                }
            }
        }
    }

    try std.testing.expectEqual(tracked.allocated_bytes, tracked.freed_bytes);

    return .{ .bytes = tracked.allocated_bytes, .allocations = tracked.allocations };
}

pub fn failures(gpa: std.mem.Allocator, enabled: bool) !void {
    _ = try run(gpa, .{ .count = 3, .length = 17, .enabled = enabled });
}
