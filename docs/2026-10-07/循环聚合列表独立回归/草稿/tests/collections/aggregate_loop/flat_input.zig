const std = @import("std");
const program = @import("program");
pub const Input = @typeInfo(@typeInfo(@TypeOf(program.execute)).@"fn".param_types[1].?).pointer.child;
pub const Frame = @typeInfo(@typeInfo(@FieldType(Input, "frames")).pointer.child).pointer.child;

pub const Seed = struct {
    values: [257]Frame = undefined,
    frames: [257]*const Frame = undefined,
    pub fn init(self: *Seed) void {
        for (&self.values, &self.frames, 0..) |*value, *frame, index| {
            value.* = .{ .position = @intCast(index * 3 + 11), .count = @intCast(index * 7 + 5) };
            frame.* = value;
        }
    }

    pub fn unchanged(self: *const Seed) !void {
        for (&self.values, &self.frames, 0..) |*value, frame, index| {
            try std.testing.expectEqual(@as(u64, @intCast(index * 3 + 11)), value.position);
            try std.testing.expectEqual(@as(u64, @intCast(index * 7 + 5)), value.count);
            try std.testing.expectEqual(value, frame);
        }
    }
};
