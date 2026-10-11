const zx = @import("zx");
const syntax = zx.syntax.borrow;
const Graph = @import("types.zig");
const Expression = @import("expression.zig");

pub fn infer(self: *Expression, expression: anytype, expected: ?Graph.Id) zx.Error!Graph.Id {
    const binary = syntax.value(expression).binary;
    const span = self.sourceSpan(expression.span);
    const operator = binary.operator;

    if (operator == .logical_and or operator == .logical_or) {
        const boolean = try self.graph.scalar(.bool, span);
        _ = try self.infer(binary.left, boolean);
        const facts = self.nonnull.items.len;

        defer self.nonnull.shrinkRetainingCapacity(facts);

        try @import("../condition.zig").assumeValue(binary.left, operator == .logical_and, self);

        _ = try self.infer(binary.right, boolean);

        return boolean;
    }

    if (operator == .coalesce) {
        const left = try self.declared(binary.left);
        const child = try self.graph.payload(left, .optional, span);

        if (expected) |hint| try self.graph.expect(child, hint, span);

        _ = try self.infer(binary.right, child);

        return child;
    }

    const comparison = switch (operator) {
        .equal, .not_equal, .less, .less_equal, .greater, .greater_equal => true,
        else => false,
    };

    const operands = if (!comparison and expected != null) expected.? else try self.graph.add(.unknown, span);

    if (operator != .equal and operator != .not_equal) try self.graph.restrict(operands, Graph.numeric(), span);

    _ = try self.infer(binary.left, operands);
    _ = try self.infer(binary.right, operands);

    return if (comparison) self.graph.scalar(.bool, span) else operands;
}
