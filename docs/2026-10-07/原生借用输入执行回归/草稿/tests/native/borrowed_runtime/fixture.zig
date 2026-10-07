const std = @import("std");
const program = @import("program");
const mode = @import("options").mode;
const Input = std.meta.Child(program.Input);
pub const Payload = @FieldType(Input, "payload");
pub const count: usize = if (mode == .optional) 6 else 5;

pub const Data = struct {
    bytes: [16]u8 = @splat(0),
    numbers: [5]u64 = @splat(0),
    other: [5]u64 = @splat(0),
    rows: [3][]const u64 = @splat(&.{}),
    score: u64 = 0,
    length: usize = 0,
    present: bool = true,
    pub fn init(self: *Data, index: usize) Payload {
        self.* = .{};

        if (comptime mode == .string or mode == .optional) {
            if (mode == .optional and index == 5) {
                self.present = false;

                return null;
            }

            const texts = [_][]const u8{ "", "abc", "a\x00b", "中文", "😀" };
            const scores = [_]u64{ 0, 590, 391, 3595, 1526 };
            const text = texts[index];

            @memcpy(self.bytes[0..text.len], text);

            self.score = scores[index];
            self.length = text.len;

            return self.bytes[0..text.len];
        } else if (comptime mode == .list) {
            const values = [_][]const u64{ &.{}, &.{ 3, 7, 11 }, &.{ 0, 0 }, &.{ 65535, 1 }, &.{ 7, 7, 7 } };
            const scores = [_]u64{ 0, 50, 0, 65537, 42 };
            const value = values[index];

            @memcpy(self.numbers[0..value.len], value);

            self.score = scores[index];
            self.length = value.len;

            return self.numbers[0..value.len];
        } else {
            self.numbers[0..3].* = .{ 3, 7, 11 };
            self.other[0] = 7;

            switch (index) {
                0 => {},
                1 => {
                    self.rows[0..3].* = .{ self.numbers[0..2], self.other[0..0], self.numbers[2..3] };
                    self.score = 1335;
                    self.length = 3;
                },
                2 => {
                    self.rows[0] = self.numbers[0..0];
                    self.length = 1;
                },
                3 => {
                    self.rows[0..2].* = .{ self.numbers[1..2], self.other[0..1] };
                    self.score = 792;
                    self.length = 2;
                },
                4 => {
                    self.rows[0..2].* = .{ self.numbers[0..2], self.numbers[0..2] };
                    self.score = 1593;
                    self.length = 2;
                },
                else => unreachable,
            }

            return self.rows[0..self.length];
        }
    }

    pub fn preserved(self: *const Data, before: Data) !void {
        try std.testing.expectEqualDeep(before.bytes, self.bytes);
        try std.testing.expectEqualDeep(before.numbers, self.numbers);
        try std.testing.expectEqualDeep(before.other, self.other);
        try std.testing.expectEqual(before.score, self.score);
        try std.testing.expectEqual(before.length, self.length);
        try std.testing.expectEqual(before.present, self.present);

        for (before.rows, self.rows) |first, second| {
            try std.testing.expectEqual(first.ptr, second.ptr);
            try std.testing.expectEqual(first.len, second.len);
        }
    }
};
