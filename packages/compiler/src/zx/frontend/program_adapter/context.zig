const std = @import("std");
const zx = @import("zx");

pub fn init(allocator: std.mem.Allocator, source: []const u8, body: anytype) !Tables(@TypeOf(body)) {
    return .{
        .allocator = allocator,
        .source = source,
        .body = body,
        .types = try allocator.alloc(zx.ast.Type, body.expression.types.tree.nodes.len),
        .expressions = try allocator.alloc(zx.ast.Expression, body.expression.tree.nodes.len),
        .blocks = try allocator.alloc(zx.ast.Block, body.tree.blocks.len),
    };
}

fn Tables(comptime Body: type) type {
    return struct {
        allocator: std.mem.Allocator,
        source: []const u8,
        body: Body,
        types: []zx.ast.Type,
        expressions: []zx.ast.Expression,
        blocks: []zx.ast.Block,
        pub fn text(self: @This(), value: anytype) []const u8 {
            return self.source[@intCast(value.start)..@intCast(value.end)];
        }
        pub fn name(self: @This(), value: anytype) zx.ast.Name {
            return .{ .text = self.text(value), .span = span(value) };
        }
        pub fn expression(self: @This(), index: u64) *const zx.ast.Expression {
            return &self.expressions[@intCast(index)];
        }
        pub fn typeValue(self: @This(), index: u64) *const zx.ast.Type {
            return &self.types[@intCast(index)];
        }
        pub fn block(self: @This(), index: u64) zx.ast.Block {
            return self.blocks[@intCast(index)];
        }
    };
}

pub fn span(value: anytype) zx.Span {
    return .{ .start = @intCast(value.start), .end = @intCast(value.end) };
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
