const std = @import("std");

pub fn total(count: u64) u64 {
    var result: u64 = 0;

    for (0..@intCast(count)) |_| result = result * 4 + 2;

    return result;
}

pub fn check(columns: []const u64, initial: []const u64, count: u64) !void {
    try std.testing.expectEqual(initial.len + count, columns.len);
    try std.testing.expectEqualSlices(u64, initial, columns[0..initial.len]);
    for (0..@intCast(count)) |index| try std.testing.expectEqual(total(@intCast(index + 1)), columns[initial.len + index]);
}
