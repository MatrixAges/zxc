const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Self = @import("../lower.zig");
const Error = Self.Error;

pub fn binary(self: *Self, value: @FieldType(@FieldType(ir.ExpressionRow, "value"), "binary")) Error!node.ExpressionId {
    const left = try self.expr(value.left);
    const right = try self.expr(value.right);
    const type_id = self.program.expression(value.left).type_id;
    const target = self.program.typeOf(type_id);

    if ((value.operator == .equal or value.operator == .not_equal) and target == .optional and (self.program.expression(value.left).value == .none or self.program.expression(value.right).value == .none)) {
        return self.builder.expression(.{ .binary = .{ .operator = if (value.operator == .equal) .equal else .not_equal, .left = if (self.program.expression(value.left).value == .none) try self.builder.expression(.null_value) else left, .right = if (self.program.expression(value.right).value == .none) try self.builder.expression(.null_value) else right } });
    }

    if ((value.operator == .equal or value.operator == .not_equal) and (target == .optional or (target == .scalar and target.scalar == .string))) {
        const equal = try @import("../comparison.zig").equal(self, type_id, left, right);

        return if (value.operator == .equal) equal else self.builder.expression(.{ .unary = .{ .operator = .not, .operand = equal } });
    }

    const floating = target == .scalar and (target.scalar == .f32 or target.scalar == .f64);

    if (value.operator == .remainder and target == .scalar and (target.scalar == .i32 or target.scalar == .i64)) {
        const wide = try self.builder.expression(.{ .primitive = if (target.scalar == .i32) .i33 else .i65 });
        const remainder = try self.builtin(.rem, &.{ try self.cast(wide, left), try self.cast(wide, right) });

        return self.cast(try self.typeExpr(type_id), try self.builtin(.intCast, &.{remainder}));
    }

    if (value.operator == .remainder or (value.operator == .divide and !floating)) return self.builtin(if (value.operator == .divide) .divTrunc else .rem, &.{ left, right });

    return self.builder.expression(.{ .binary = .{ .operator = std.meta.stringToEnum(node.BinaryOperator, @tagName(value.operator)).?, .left = left, .right = right } });
}
