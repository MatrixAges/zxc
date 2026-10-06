const std = @import("std");
const program = @import("program");
pub const Input = std.meta.Child(program.Input);
pub const Cell = std.meta.Child(std.meta.Child(@FieldType(Input, "seed")));
const words = [_][]const u8{ "", "same", "中文", "a\x00b", "😀", "same" };

pub const Seed = struct {
    bytes: [257][32]u8 = undefined,
    values: [257]Cell = undefined,
    pointers: [257]*const Cell = undefined,
    pub fn init(self: *Seed) void {
        for (&self.bytes, &self.values, &self.pointers, 0..) |*bytes, *value, *pointer, index| {
            const word = words[index % words.len];

            @memset(bytes, 0);
            @memcpy(bytes[0..word.len], word);

            value.* = .{ .value = @intCast(index * 5 + 3), .label = bytes[0..word.len] };
            pointer.* = value;
        }
    }

    pub fn unchanged(self: *const Seed) !void {
        for (&self.bytes, &self.values, self.pointers, 0..) |*bytes, *value, pointer, index| {
            const word = words[index % words.len];
            var expected: [32]u8 = @splat(0);

            @memcpy(expected[0..word.len], word);

            try std.testing.expectEqualSlices(u8, &expected, bytes);
            try std.testing.expectEqual(@as(u64, @intCast(index * 5 + 3)), value.value);
            try std.testing.expectEqualStrings(word, value.label);
            try std.testing.expectEqual(bytes[0..word.len].ptr, value.label.ptr);
            try std.testing.expectEqual(value, pointer);
        }
    }
};
