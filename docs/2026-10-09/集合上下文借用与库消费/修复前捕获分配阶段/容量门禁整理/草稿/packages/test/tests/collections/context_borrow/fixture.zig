const std = @import("std");
const program = @import("program");
const options = @import("options");
pub const Input = std.meta.Child(program.Input);
pub const Context = @FieldType(Input, "context");
const Stored = if (options.kind == .list) void else std.meta.Child(Context);

pub const Data = struct {
    first: [19]i64 = @splat(-87654321),
    second: [19]i64 = @splat(-87654321),
    context: Stored = undefined,
    score: i64 = 0,
    pub fn init(self: *Data, variant: usize) Context {
        self.* = .{};

        const samples = [_][]const i64{ &.{}, &.{ 3, -1, 2 }, &.{ 0, 0 }, &.{ 7, 7, 7 }, &.{ 3, -1, 2 } };
        const values = samples[variant];

        @memcpy(self.first[1..][0..values.len], values);

        self.second[1..3].* = .{ 4, 1 };

        const left = if (variant == 4) self.first[2..4] else self.first[1..][0..values.len];

        if (options.kind == .list) {
            self.score = ([_]i64{ 0, 7, 0, 42, 3 })[variant];

            return left;
        } else if (options.kind == .object) {
            self.context = .{ .limit = ([_]i64{ -1, -3, 0, 5, -2 })[variant], .payload = left };
            self.score = ([_]i64{ -1, 4, 0, 47, 1 })[variant];
        } else {
            const right = if (variant == 0 or variant == 2) self.second[1..1] else if (variant == 3) left else if (variant == 4) self.first[1..3] else self.second[1..3];

            self.context = .{ .left = left, .right = right, .active = variant == 1 or variant == 4 };
            self.score = ([_]i64{ 0, 2, 0, 0, 3 })[variant];
        }

        return &self.context;
    }
};
