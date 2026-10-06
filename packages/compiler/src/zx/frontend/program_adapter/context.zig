const std = @import("std");
const zx = @import("zx");
const generated = @import("generated_parser");
const Self = @This();
pub const Program = @FieldType(@typeInfo(generated.Output).pointer.child, "program");

allocator: std.mem.Allocator,
source: []const u8,
program: Program,
types: []zx.ast.Type,
expressions: []zx.ast.Expression,
blocks: []zx.ast.Block,
pub fn span(value: anytype) zx.Span {
    return .{ .start = @intCast(value.start), .end = @intCast(value.end) };
}

pub fn text(self: Self, value: anytype) []const u8 {
    return self.source[@intCast(value.start)..@intCast(value.end)];
}

pub fn name(self: Self, value: anytype) zx.ast.Name {
    return .{ .text = self.text(value), .span = span(value) };
}

pub fn expression(self: Self, index: u64) *const zx.ast.Expression {
    return &self.expressions[@intCast(index)];
}

pub fn typeValue(self: Self, index: u64) *const zx.ast.Type {
    return &self.types[@intCast(index)];
}

pub fn block(self: Self, index: u64) zx.ast.Block {
    return self.blocks[@intCast(index)];
}

pub fn operator(value: anytype) zx.syntax.Operator {
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
