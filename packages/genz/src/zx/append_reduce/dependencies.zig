const std = @import("std");
const ir = @import("zx").ir;

pub fn analyze(allocator: std.mem.Allocator, expressions: []const ir.Expression, symbol: ir.SymbolId) ![]bool {
    const result = try allocator.alloc(bool, expressions.len);

    for (expressions, 0..) |expression, index| {
        result[index] = switch (expression.value) {
            .iteration => |value| result[@intFromEnum(value.initial)] or result[@intFromEnum(value.condition)] or result[@intFromEnum(value.body)],
            .list_update => |value| result[@backingInt(value.target)] or result[@backingInt(value.index)] or result[@backingInt(value.value)],
            .scope => |scope| blk: {
                for (scope.bindings) |binding| if (result[@backingInt(binding.value)]) break :blk true;

                break :blk result[@backingInt(scope.result)];
            },
            .reference => |value| value == symbol,
            .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .store_get => false,
            .some, .length => |value| result[@backingInt(value)],
            .field, .tuple_field => |value| result[@backingInt(value.target)],
            .index => |value| result[@backingInt(value.target)] or result[@backingInt(value.index)],
            .list, .tuple, .template => |values| any(result, values),
            .list_operation => |value| result[@backingInt(value.target)] or any(result, value.arguments),
            .transform => |value| result[@backingInt(value.target)] or result[@backingInt(value.body)] or (if (value.initial) |initial| result[@backingInt(initial)] else false),
            .call => |value| result[@backingInt(value.argument)],
            .unary => |value| result[@backingInt(value.operand)],
            .binary => |value| result[@backingInt(value.left)] or result[@backingInt(value.right)],
            .conditional => |value| result[@backingInt(value.condition)] or result[@backingInt(value.yes)] or result[@backingInt(value.no)],
            .match_expr => |value| blk: {
                if (value.subject) |subject| if (result[@backingInt(subject)]) break :blk true;
                if (result[@backingInt(value.fallback)]) break :blk true;
                for (value.arms) |arm| if (result[@backingInt(arm.condition)] or result[@backingInt(arm.result)]) break :blk true;

                break :blk false;
            },
            .object => |value| blk: {
                if (any(result, value.evaluation)) break :blk true;
                for (value.fields) |field| if (result[@backingInt(field.value)]) break :blk true;

                break :blk false;
            },
        };
    }

    return result;
}

fn any(values: []const bool, ids: []const ir.ExprId) bool {
    for (ids) |id| if (values[@backingInt(id)]) return true;

    return false;
}
