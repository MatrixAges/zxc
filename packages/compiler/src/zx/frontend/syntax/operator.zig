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
