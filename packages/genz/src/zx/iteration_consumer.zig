const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub const Consumer = struct { symbol: ir.SymbolId, result: ir.ExprId, layout: bool = false };

pub fn lower(self: *Lower, symbol: ir.SymbolId, value: ir.ExprId, result: ir.ExprId, layout: bool) Lower.Error!?node.ExpressionId {
    if (self.cache.contains(value)) return null;
    if (self.program.expression(value).value != .iteration) return null;

    if (!self.cache.contains(result)) {
        const selected = Consumer{ .symbol = symbol, .result = result, .layout = layout };

        if (try @import("simd/iteration.zig").lower(self, self.program.expression(value).value.iteration, selected)) |vector| return vector;
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

        if (try @import("iteration_value/result.zig").eligible(self, selected)) {
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

pub fn read(self: *Lower, consumer: Consumer, id: ir.ExprId, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    const expression = self.program.expression(id);

    return switch (expression.value) {
        .reference => |symbol| if (symbol == consumer.symbol) state else unreachable,
        .field, .tuple_field => |field| value: {
            const target = try read(self, consumer, field.target, state);
            const type_id = self.program.expression(field.target).type_id;
            const kind = self.program.typeOf(type_id);
            const name = if (expression.value == .field) kind.object.at(field.index).name else try std.fmt.allocPrint(self.allocator, "{d}", .{field.index});
            const projected = try self.field(target, name);

            if (!self.state_active or self.state_plan.represented(self.program, type_id)) break :value projected;

            break :value fromAbi(self, expression.type_id, projected);
        },
        .index => |item| value: {
            const projected = try @import("intrinsics.zig").index(self, try @import("state_value/list.zig").items(self, self.program.expression(item.target).type_id, try read(self, consumer, item.target, state)), try self.expr(item.index));

            break :value if (self.state_active) fromAbi(self, expression.type_id, projected) else projected;
        },
        .length => |child| self.cast(try self.typeExpr(expression.type_id), try self.field(try @import("state_value/list.zig").items(self, self.program.expression(child).type_id, try read(self, consumer, child, state)), "len")),
        else => unreachable,
    };
}

fn fromAbi(self: *Lower, id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!self.state_plan.represented(self.program, id)) return value;
    if (self.program.typeOf(id) == .list) return @import("state_value/list.zig").borrowed(self, id, value);

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try @import("aggregate.zig").bind(self, &body, value);
    const converted = try @import("state_value/conversion.zig").convert(self, &body, id, source, .value);

    return @import("aggregate.zig").finish(self, &body, converted);
}
