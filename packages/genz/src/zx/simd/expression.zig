const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn supported(program: ir.Program, id: ir.ExprId, element: ir.SymbolId, type_id: ir.TypeId) bool {
    const expression = program.expression(id);

    if (expression.type_id != type_id) return false;

    return switch (expression.value) {
        .integer, .negative_integer, .float => true,
        .reference => |symbol| symbol == element,
        .unary => |value| value.operator == .negate and supported(program, value.operand, element, type_id),
        .binary => |value| switch (value.operator) {
            .add, .subtract, .multiply, .divide => supported(program, value.left, element, type_id) and supported(program, value.right, element, type_id),
            else => false,
        },
        else => false,
    };
}

pub fn lower(self: *Lower, id: ir.ExprId, vector_type: *const node.Expression, element: *const node.Expression) Lower.Error!*const node.Expression {
    return switch (self.program.expression(id).value) {
        .reference => element,
        .unary => |value| self.builder.expression(.{ .unary = .{ .operator = .negate, .operand = try lower(self, value.operand, vector_type, element) } }),
        .binary => |value| self.builder.expression(.{ .binary = .{
            .operator = switch (value.operator) {
                .add => .add,
                .subtract => .subtract,
                .multiply => .multiply,
                .divide => .divide,
                else => unreachable,
            },
            .left = try lower(self, value.left, vector_type, element),
            .right = try lower(self, value.right, vector_type, element),
        } }),
        .integer, .negative_integer, .float => self.cast(vector_type, try self.builtin(.splat, &.{try self.expr(id)})),
        else => unreachable,
    };
}
