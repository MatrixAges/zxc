const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");
const Scalar = @import("scalar.zig");

pub fn infer(self: *Expression, expression: anytype, expected: ?Graph.Id) zx.Error!Graph.Id {
    const binary = syntax.value(expression).binary;
    const span = self.sourceSpan(expression.span);
    const operator = Scalar.operator(binary.operator);

    if (operator.route == .and_value or operator.route == .or_value) {
        const boolean = try self.graph.scalar(.bool, span);
        _ = try self.infer(binary.left, boolean);
        const facts = self.nonnull.items.len;

        defer self.nonnull.shrinkRetainingCapacity(facts);

        try @import("../condition.zig").assumeValue(binary.left, operator.route == .and_value, self);

        _ = try self.infer(binary.right, boolean);

        return boolean;
    }

    if (operator.route == .coalesce) {
        const left = try self.declared(binary.left);
        const child = try self.graph.payload(left, .optional, span);

        if (expected) |hint| try self.graph.expect(child, hint, span);

        _ = try self.infer(binary.right, child);

        return child;
    }

    const comparison = operator.route == .compare;
    const operands = if (!comparison and expected != null) expected.? else try self.graph.add(.unknown, span);

    if (operator.allowed) |mask| try self.graph.restrict(operands, mask, span);

    _ = try self.infer(binary.left, operands);
    _ = try self.infer(binary.right, operands);

    return if (comparison) self.graph.scalar(.bool, span) else operands;
}
