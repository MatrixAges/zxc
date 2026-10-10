const std = @import("std");
const zx = @import("zx");

pub fn get(value: anytype) zx.syntax.Operator {
    return switch (value) {
        .Coalesce => .coalesce,
        .Add => .add,
        .Subtract => .subtract,
        .Multiply => .multiply,
        .Divide => .divide,
        .Remainder => .remainder,
        .Equal => .equal,
        .NotEqual => .not_equal,
        .Less => .less,
        .LessEqual => .less_equal,
        .Greater => .greater,
        .GreaterEqual => .greater_equal,
        .And => .logical_and,
        .Or => .logical_or,
        .None => unreachable,
    };
}

pub fn fromNative(comptime Target: type, value: zx.syntax.Operator) Target {
    inline for (std.enums.values(Target)) |candidate| {
        if (comptime candidate == .None) continue;
        if (value == comptime get(candidate)) return candidate;
    }

    unreachable;
}
