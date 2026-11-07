const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn tuple(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("root.zig").selected(self, id) or self.program.typeOf(id) != .tuple) return value;

    const expression = self.builder.nodes.get(value);

    if (expression == .conditional) {
        var conditional = expression.conditional;
        conditional.yes = try tuple(self, id, conditional.yes);
        conditional.no = try tuple(self, id, conditional.no);

        return self.builder.expression(.{ .conditional = conditional });
    }

    if (expression != .tuple) return value;
    if (expression.tuple.len != self.program.typeOf(id).tuple.len) return value;

    const items = try self.allocator.alloc(node.ExpressionId, expression.tuple.len + 1);

    @memcpy(items[0..expression.tuple.len], expression.tuple);

    items[expression.tuple.len] = try self.builder.expression(.null_value);

    return self.builder.expression(.{ .tuple = items });
}
