const std = @import("std");
const h = @import("check.zig");

test "function updates bound list payload allocations across repeated writes" {
    const length = 65537;
    const bytes = try h.run(std.testing.allocator, .{ .length = length, .outer = if (h.isMode("mixed")) 2 else 17, .inner = 64, .forbid_resize = true });

    try std.testing.expect(bytes < length * @sizeOf(i64) * 8);
}
