const std = @import("std");
const h = @import("check.zig");

test "fresh call origins transfer the first backing and avoid round proportional copies" {
    for ([_]bool{ false, true }) |enabled| {
        for ([_]usize{ 2048, 16384 }) |length| {
            const initial = try h.run(std.testing.allocator, .{ .count = 0, .length = length, .enabled = enabled, .forbid_resize = true });
            const first = try h.run(std.testing.allocator, .{ .count = 1, .length = length, .enabled = enabled, .forbid_resize = true });
            const long = try h.run(std.testing.allocator, .{ .count = 64, .length = length, .enabled = enabled, .forbid_resize = true });
            const payload = length * @sizeOf(u64);

            std.debug.print("call origin length={d} enabled={} initial={d} first={d} long={d} payload={d}\n", .{ length, enabled, initial.bytes, first.bytes, long.bytes, payload });

            try std.testing.expect(first.bytes < initial.bytes + payload);
            try std.testing.expectEqual(first.bytes, long.bytes);
            try std.testing.expectEqual(first.allocations, long.allocations);
        }
    }
}
