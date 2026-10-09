const std = @import("std");
const pattern = @import("pattern.zig");
const Bits = pattern.Bits;
const Scalar = pattern.Scalar;
const Self = @This();

left: [8194]Bits = @splat(std.math.maxInt(Bits)),
right: [8194]Bits = @splat(std.math.maxInt(Bits)),
pub fn input(self: *Self, values: pattern.Values) !pattern.Input {
    try std.testing.expect(values.left.length <= self.left.len - 2);
    try std.testing.expect(values.right.length <= self.right.len - 2);
    try pattern.fill(self.left[1..][0..values.left.length], values.left);
    try pattern.fill(self.right[1..][0..values.right.length], values.right);

    return .{
        .left = std.mem.bytesAsSlice(Scalar, std.mem.sliceAsBytes(self.left[1..][0..values.left.length])),
        .right = std.mem.bytesAsSlice(Scalar, std.mem.sliceAsBytes(self.right[1..][0..values.right.length])),
        .marker = @bitCast(values.marker),
    };
}

pub fn expect(self: *const Self, before: *const Self, actual: *const pattern.Input, original: pattern.Input) !void {
    try std.testing.expectEqualSlices(Bits, &before.left, &self.left);
    try std.testing.expectEqualSlices(Bits, &before.right, &self.right);
    try std.testing.expectEqual(@as(Bits, @bitCast(original.marker)), @as(Bits, @bitCast(actual.marker)));
    try std.testing.expectEqual(original.left.len, actual.left.len);
    try std.testing.expectEqual(original.right.len, actual.right.len);
    try std.testing.expectEqual(@intFromPtr(original.left.ptr), @intFromPtr(actual.left.ptr));
    try std.testing.expectEqual(@intFromPtr(original.right.ptr), @intFromPtr(actual.right.ptr));
}
