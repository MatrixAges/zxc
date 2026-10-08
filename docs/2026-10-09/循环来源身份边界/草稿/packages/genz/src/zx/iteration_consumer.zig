const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub const Consumer = struct { symbol: ir.SymbolId, result: ir.ExprId, layout: bool = false };

pub fn lower(self: *Lower, symbol: ir.SymbolId, value: ir.ExprId, result: ir.ExprId, layout: bool) Lower.Error!?*const node.Expression {
    if (self.transaction() or self.cache.contains(value)) return null;
    if (self.program.expression(value).value != .iteration) return null;

    const scalar = switch (self.program.typeOf(self.program.expression(result).type_id)) {
        .scalar => |kind| kind != .string and kind != .void,
        .enumeration, .error_set => true,
        else => false,
    };

    if (!scalar) {
        const selected = Consumer{ .symbol = symbol, .result = result, .layout = layout };

        if (self.capture != null or self.cache.contains(result)) return null;

        if (try @import("iteration_value/result.zig").eligible(self, selected)) {
            if (try @import("iteration_value/local.zig").lower(self, self.program.expression(value).value.iteration, selected)) |local| return local;
            if (try @import("iteration.zig").consume(self, value, selected)) |local| return local;
        }

        if (self.program.typeOf(self.program.expression(result).type_id) != .list or !projection(self.program, result, symbol)) return null;

        return @import("iteration.zig").consume(self, value, selected);
    }

    if (!projection(self.program, result, symbol)) return null;

    return @import("iteration.zig").consume(self, value, .{ .symbol = symbol, .result = result });
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

pub fn read(self: *Lower, consumer: Consumer, id: ir.ExprId, state: *const node.Expression) Lower.Error!*const node.Expression {
    const expression = self.program.expression(id);

    return switch (expression.value) {
        .reference => |symbol| if (symbol == consumer.symbol) state else unreachable,
        .field, .tuple_field => |field| value: {
            const target = try read(self, consumer, field.target, state);
            const type_id = self.program.expression(field.target).type_id;
            const kind = self.program.typeOf(type_id);
            const name = if (expression.value == .field) kind.object.at(field.index).name else try std.fmt.allocPrint(self.allocator, "{d}", .{field.index});

            break :value self.field(target, name);
        },
        .index => |item| @import("intrinsics.zig").index(self, try read(self, consumer, item.target, state), try self.expr(item.index)),
        .length => |child| self.cast(self.types[@backingInt(expression.type_id)], try self.field(try read(self, consumer, child, state), "len")),
        else => unreachable,
    };
}
