const std = @import("std");
const program = @import("program");
pub const Input = std.meta.Child(program.Input);
pub const Frame = std.meta.Child(std.meta.Child(@FieldType(Input, "frames")));

pub const Seed = struct {
    values: [257]Frame = undefined,
    frames: [257]*const Frame = undefined,
    columns: [257]u64 = undefined,
    pub fn init(self: *Seed) void {
        for (&self.values, &self.frames, &self.columns, 0..) |*value, *frame, *column, index| {
            value.* = .{ .position = @intCast(index * 3 + 11), .count = @intCast(index * 7 + 5) };
            frame.* = value;
            column.* = @intCast(index + 1000);
        }
    }

    pub fn unchanged(self: *const Seed) !void {
        for (&self.values, &self.frames, &self.columns, 0..) |*value, frame, column, index| {
            try std.testing.expectEqual(@as(u64, @intCast(index * 3 + 11)), value.position);
            try std.testing.expectEqual(@as(u64, @intCast(index * 7 + 5)), value.count);
            try std.testing.expectEqual(@as(u64, @intCast(index + 1000)), column);
            try std.testing.expectEqual(value, frame);
        }
    }
};
