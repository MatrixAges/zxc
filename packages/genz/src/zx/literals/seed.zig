const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, value: ir.ExpressionRow, value_type: node.ExpressionId) Lower.Error!node.ExpressionId {
    return switch (value.value) {
        .integer => |integer| self.cast(value_type, try self.builder.integer(integer)),
        .negative_integer => |integer| self.cast(value_type, try self.builder.expression(.{ .unary = .{ .operator = .negate, .operand = try self.builder.integer(integer) } })),
        .float => |float| self.cast(value_type, try self.builder.expression(.{ .float = float })),
        .boolean => |boolean| self.builder.expression(.{ .boolean = boolean }),
        .string => |text| self.cast(value_type, try self.builder.string(text)),
        .unit => self.builder.expression(.unit),
        .none => self.cast(value_type, try self.builder.expression(.null_value)),
        .enum_value => |member| self.cast(value_type, try self.builder.expression(.{ .enum_literal = self.program.typeOf(value.type_id).enumeration.members[member] })),
        .error_value => |member| self.cast(value_type, try self.builder.expression(.{ .error_value = self.program.typeOf(value.type_id).error_set[member] })),
        else => unreachable,
    };
}
