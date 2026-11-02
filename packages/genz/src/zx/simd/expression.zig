const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Plan = @import("analysis.zig").Plan;

pub fn lower(self: *Lower, plan: Plan, vector_type: ?node.ExpressionId, element: node.ExpressionId) Lower.Error!node.ExpressionId {
    const expressions = try self.allocator.alloc(node.ExpressionId, plan.expression.nodes.len);

    for (plan.expression.nodes, expressions) |item, *target| {
        target.* = switch (item.operation) {
            .Element => element,
            .Literal => if (vector_type) |type_node|
                try self.cast(type_node, try self.builtin(.splat, &.{try self.expr(@fromBackingInt(item.source))}))
            else
                try self.expr(@fromBackingInt(item.source)),
            .Negate => try self.builder.expression(.{ .unary = .{ .operator = .negate, .operand = expressions[@intCast(item.left)] } }),
            .Add, .Subtract, .Multiply, .Divide => try self.builder.expression(.{ .binary = .{
                .operator = switch (item.operation) {
                    .Add => .add,
                    .Subtract => .subtract,
                    .Multiply => .multiply,
                    .Divide => .divide,
                    else => unreachable,
                },
                .left = expressions[@intCast(item.left)],
                .right = expressions[@intCast(item.right)],
            } }),
            .Invalid => unreachable,
        };
    }

    return expressions[expressions.len - 1];
}
