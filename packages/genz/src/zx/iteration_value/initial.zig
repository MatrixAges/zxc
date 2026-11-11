const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const consumer = @import("../iteration_consumer.zig");
const Self = @This();

body: std.ArrayList(node.Statement),
condition: node.ExpressionId,
result: node.ExpressionId,
pub fn create(lowering: *Lower, body: *std.ArrayList(node.Statement), iteration: ir.Iteration, selected: ?consumer.Consumer, initial: node.ExpressionId) Lower.Error!Self {
    const outer = body.*;
    body.* = .empty;
    const name = lowering.builder.nodes.get(initial).identifier;
    const index = @backingInt(iteration.condition_parameter);
    const previous_name = lowering.names[index];
    const previous_context = lowering.iteration_value;
    lowering.names[index] = name;
    lowering.iteration_value = null;
    defer lowering.names[index] = previous_name;
    defer lowering.iteration_value = previous_context;
    const condition = try lowering.expr(iteration.condition);
    const result = if (selected) |value| try @import("result.zig").lower(lowering, value, initial) else try lowering.builder.expression(.unit);

    return .{ .body = outer, .condition = condition, .result = result };
}

pub fn finish(self: *Self, lowering: *Lower, result: node.ExpressionId) Lower.Error!node.ExpressionId {
    return aggregate.finishGuarded(lowering, &self.body, self.condition, result, self.result);
}
