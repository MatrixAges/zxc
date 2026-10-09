const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub const Context = struct {
    bindings: @FieldType(ir.ScopeRow, "bindings") = .{ .symbols = &.{}, .values = &.{}, .borrows = &.{}, .len = 0 },
    element: ?ir.SymbolId = null,
    iteration: ?struct { symbol: ir.SymbolId, source: u32, index: u32 } = null,
    pub fn resolve(self: Context, program: ir.Program, id: ir.ExprId) ir.ExprId {
        var current = id;
        var remaining = self.bindings.len;

        while (remaining > 0 and program.expression(current).value == .reference) {
            const symbol = program.expression(current).value.reference;
            var found = false;

            while (remaining > 0) {
                remaining -= 1;
                const binding = self.bindings.at(remaining);

                if (binding.symbol == symbol) {
                    current = binding.value;
                    found = true;

                    break;
                }
            }

            if (!found) break;
        }

        return current;
    }

    pub fn isElement(self: Context, program: ir.Program, id: ir.ExprId) bool {
        const value = program.expression(id).value;

        if (self.element) |symbol| return value == .reference and value.reference == symbol;

        const iteration = self.iteration orelse return false;

        return value == .index and field(program, self.resolve(program, value.index.target), iteration.symbol) == iteration.source and
            field(program, self.resolve(program, value.index.index), iteration.symbol) == iteration.index;
    }
};

pub fn field(program: ir.Program, id: ir.ExprId, symbol: ir.SymbolId) ?u32 {
    const value = program.expression(id).value;

    if (value != .field) return null;

    const target = program.expression(value.field.target).value;

    return if (target == .reference and target.reference == symbol) value.field.index else null;
}

pub fn supported(program: ir.Program, id: ir.ExprId, context: Context, type_id: ir.TypeId) bool {
    const resolved = context.resolve(program, id);
    const expression = program.expression(resolved);

    if (expression.type_id != type_id) return false;
    if (context.isElement(program, resolved)) return true;

    return switch (expression.value) {
        .integer, .negative_integer, .float => true,
        .unary => |value| value.operator == .negate and supported(program, value.operand, context, type_id),
        .binary => |value| switch (value.operator) {
            .add, .subtract, .multiply, .divide => supported(program, value.left, context, type_id) and supported(program, value.right, context, type_id),
            else => false,
        },
        else => false,
    };
}

pub fn lower(self: *Lower, id: ir.ExprId, context: Context, vector_type: ?*const node.Expression, element: *const node.Expression) Lower.Error!*const node.Expression {
    const resolved = context.resolve(self.program, id);

    if (context.isElement(self.program, resolved)) return element;

    return switch (self.program.expression(resolved).value) {
        .unary => |value| self.builder.expression(.{ .unary = .{ .operator = .negate, .operand = try lower(self, value.operand, context, vector_type, element) } }),
        .binary => |value| self.builder.expression(.{ .binary = .{
            .operator = switch (value.operator) {
                .add => .add,
                .subtract => .subtract,
                .multiply => .multiply,
                .divide => .divide,
                else => unreachable,
            },
            .left = try lower(self, value.left, context, vector_type, element),
            .right = try lower(self, value.right, context, vector_type, element),
        } }),
        .integer, .negative_integer, .float => if (vector_type) |type_node| self.cast(type_node, try self.builtin(.splat, &.{try self.expr(resolved)})) else self.expr(resolved),
        else => unreachable,
    };
}

pub fn usesElement(program: ir.Program, id: ir.ExprId, context: Context) bool {
    const resolved = context.resolve(program, id);

    if (context.isElement(program, resolved)) return true;

    return switch (program.expression(resolved).value) {
        .unary => |value| usesElement(program, value.operand, context),
        .binary => |value| usesElement(program, value.left, context) or usesElement(program, value.right, context),
        else => false,
    };
}
