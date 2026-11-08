const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;

pub fn lower(self: *Lower, symbol: ir.SymbolId, value: ir.ExprId, result: ir.ExprId, layout: bool) Lower.Error!?node.ExpressionId {
    if (self.cache.contains(value)) return null;
    if (self.program.expression(value).value != .iteration) return null;

    if (!self.cache.contains(result)) {
        const selected = Consumer{ .symbol = symbol, .result = result, .layout = layout };

        if (try @import("../simd/iteration.zig").lower(self, value, selected)) |vector| return vector;
    }

    if (self.transaction()) return null;

    const scalar = switch (self.program.typeOf(self.program.expression(result).type_id)) {
        .scalar => |kind| kind != .string and kind != .void,
        .enumeration, .error_set => true,
        else => false,
    };

    if (!scalar) {
        const selected = Consumer{ .symbol = symbol, .result = result, .layout = layout };

        if (self.capture != null or self.cache.contains(result)) return null;

        if (try @import("../iteration_value/result.zig").eligible(self, selected)) {
            if (try @import("../iteration.zig").consume(self, value, selected)) |local| return local;
        }

        if (self.program.typeOf(self.program.expression(result).type_id) != .list or !projection(self.program, result, symbol)) return null;

        return @import("../iteration.zig").consume(self, value, selected);
    }

    if (!projection(self.program, result, symbol)) return null;

    return @import("../iteration.zig").consume(self, value, .{ .symbol = symbol, .result = result });
}

pub fn projection(program: ir.Program, result: ir.ExprId, symbol: ir.SymbolId) bool {
    var current = result;

    while (true) switch (program.expression(current).value) {
        .reference => |id| return id == symbol,
        .field, .tuple_field => |field| current = field.target,
        .length => |target| current = target,
        .index => |item| {
            if (!independent(program, item.index, symbol)) return false;

            current = item.target;
        },
        else => return false,
    };
}

pub fn independent(program: ir.Program, id: ir.ExprId, symbol: ir.SymbolId) bool {
    return switch (program.expression(id).value) {
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value => true,
        .reference => |reference| reference != symbol,
        .some, .optional_value, .length => |child| independent(program, child, symbol),
        .field, .tuple_field => |field| independent(program, field.target, symbol),
        .index => |item| independent(program, item.target, symbol) and independent(program, item.index, symbol),
        .unary => |item| independent(program, item.operand, symbol),
        .binary => |item| independent(program, item.left, symbol) and independent(program, item.right, symbol),
        .conditional => |item| independent(program, item.condition, symbol) and independent(program, item.yes, symbol) and independent(program, item.no, symbol),
        .call => |call| independent(program, call.argument, symbol),
        .object => |object| result: {
            for (object.evaluation) |child| if (!independent(program, child, symbol)) break :result false;

            for (0..object.fields.len) |record_index| {
                const field = object.fields.at(record_index);

                if (!independent(program, field.value, symbol)) break :result false;
            }

            break :result true;
        },
        .list, .tuple, .template => |children| result: {
            for (children) |child| if (!independent(program, child, symbol)) break :result false;

            break :result true;
        },
        else => false,
    };
}
