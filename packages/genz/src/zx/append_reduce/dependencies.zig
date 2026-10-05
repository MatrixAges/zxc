const std = @import("std");
const ir = @import("zx").ir;

pub fn analyze(allocator: std.mem.Allocator, expressions: []const ir.Expression, symbol: ir.SymbolId) ![]bool {
    const result = try allocator.alloc(bool, expressions.len);

    for (expressions, 0..) |expression, index| {
        result[index] = switch (expression.value) {
            .reference => |value| value == symbol,
            .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .store_get => false,
            .some, .length => |value| result[@intFromEnum(value)],
            .field, .tuple_field => |value| result[@intFromEnum(value.target)],
            .index => |value| result[@intFromEnum(value.target)] or result[@intFromEnum(value.index)],
            .list, .tuple, .template => |values| any(result, values),
            .list_operation => |value| result[@intFromEnum(value.target)] or any(result, value.arguments),
            .transform => |value| result[@intFromEnum(value.target)] or result[@intFromEnum(value.body)] or (if (value.initial) |initial| result[@intFromEnum(initial)] else false),
            .call => |value| result[@intFromEnum(value.argument)],
            .unary => |value| result[@intFromEnum(value.operand)],
            .binary => |value| result[@intFromEnum(value.left)] or result[@intFromEnum(value.right)],
            .conditional => |value| result[@intFromEnum(value.condition)] or result[@intFromEnum(value.yes)] or result[@intFromEnum(value.no)],
            .match_expr => |value| blk: {
                if (value.subject) |subject| if (result[@intFromEnum(subject)]) break :blk true;
                if (result[@intFromEnum(value.fallback)]) break :blk true;
                for (value.arms) |arm| if (result[@intFromEnum(arm.condition)] or result[@intFromEnum(arm.result)]) break :blk true;

                break :blk false;
            },
            .object => |value| blk: {
                if (any(result, value.evaluation)) break :blk true;
                for (value.fields) |field| if (result[@intFromEnum(field.value)]) break :blk true;

                break :blk false;
            },
        };
    }

    return result;
}

fn any(values: []const bool, ids: []const ir.ExprId) bool {
    for (ids) |id| if (values[@intFromEnum(id)]) return true;

    return false;
}
