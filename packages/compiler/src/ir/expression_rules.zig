const std = @import("std");
const ir = @import("zx").ir;
const Types = @import("../analysis/types.zig");
const numbers = @import("../analysis/numbers.zig");
const bool_type = Types.scalarId(.bool);
const string_type = Types.scalarId(.string);
const void_type = Types.scalarId(.void);

pub fn validate(program: ir.Program, expression: ir.Expression, index: usize) bool {
    const type_id = expression.type_id;

    if (@intFromEnum(type_id) >= program.types.len) return false;

    const target = program.typeOf(type_id);
    const check = Check{ .program = program, .index = index };

    return switch (expression.value) {
        .integer, .negative_integer => |magnitude| blk: {
            if (!numbers.isInteger(type_id)) break :blk false;

            const negative = expression.value == .negative_integer;

            if (negative and !numbers.isSigned(type_id)) break :blk false;

            const maximum: u64 = switch (target.scalar) {
                .u8 => std.math.maxInt(u8),
                .u16 => std.math.maxInt(u16),
                .u32 => std.math.maxInt(u32),
                .u64 => std.math.maxInt(u64),
                .i32 => @as(u64, std.math.maxInt(i32)) + @intFromBool(negative),
                .i64 => @as(u64, std.math.maxInt(i64)) + @intFromBool(negative),
                else => unreachable,
            };

            break :blk magnitude <= maximum;
        },
        .float => |value| numbers.isFloat(type_id) and std.math.isFinite(value) and (type_id != Types.scalarId(.f32) or @as(f64, @as(f32, @floatCast(value))) == value),
        .string => type_id == string_type,
        .boolean => type_id == bool_type,
        .unit => type_id == void_type,
        .none => target == .optional,
        .some => |child| target == .optional and check.typed(child, target.optional),
        .enum_value => |member| target == .enumeration and member < target.enumeration.members.len,
        .store_get => |slot| slot < program.stores.len and program.stores[slot].readable and program.stores[slot].type_id == type_id,
        .reference => |symbol| @intFromEnum(symbol) < program.symbols.len and program.symbols[@intFromEnum(symbol)].type_id == type_id,
        .field, .tuple_field => |field| blk: {
            if (!check.earlier(field.target)) break :blk false;

            const base = program.typeOf(program.expression(field.target).type_id);

            break :blk if (expression.value == .field)
                base == .object and field.index < base.object.len and base.object[field.index].type_id == type_id

            else
                base == .tuple and field.index < base.tuple.len and base.tuple[field.index] == type_id;
        },
        .index => |item| blk: {
            if (!check.earlier(item.target) or !check.typed(item.index, Types.scalarId(.u64))) break :blk false;

            const base = program.typeOf(program.expression(item.target).type_id);

            break :blk base == .list and base.list == type_id;
        },
        .length => |child| blk: {
            if (!check.earlier(child) or type_id != Types.scalarId(.u64)) break :blk false;

            const child_type = program.expression(child).type_id;

            break :blk program.typeOf(child_type) == .list or child_type == string_type;
        },
        .clone => |child| check.typed(child, type_id),
        .list, .tuple => |items| blk: {
            if (expression.value == .list and target != .list) break :blk false;
            if (expression.value == .tuple and (target != .tuple or target.tuple.len != items.len)) break :blk false;

            for (items, 0..) |item, item_index| {
                if (!check.typed(item, if (target == .list) target.list else target.tuple[item_index])) break :blk false;
            }

            break :blk true;
        },
        .object => |object| blk: {
            if (target != .object or target.object.len != object.fields.len) break :blk false;

            for (object.evaluation) |item| if (!check.earlier(item)) {
                break :blk false;
            };

            for (object.fields, 0..) |field, field_index| {
                if (field.index >= target.object.len or !check.typed(field.value, target.object[field.index].type_id)) break :blk false;

                for (object.fields[0..field_index]) |previous| if (previous.index == field.index) {
                    break :blk false;
                };
            }

            break :blk true;
        },
        .template => |parts| blk: {
            if (type_id != string_type) break :blk false;

            for (parts) |part| {
                if (!check.earlier(part)) break :blk false;

                const child_type = program.expression(part).type_id;

                if (child_type == void_type or program.typeOf(child_type) != .scalar) break :blk false;
            }

            break :blk true;
        },
        .unary => |unary| check.typed(unary.operand, type_id) and (if (unary.operator == .not) type_id == bool_type else numbers.isSigned(type_id) or numbers.isFloat(type_id)),
        .binary => |binary| check.binary(binary, type_id),
        .conditional => |value| check.typed(value.condition, bool_type) and check.typed(value.yes, type_id) and check.typed(value.no, type_id),
        .call => |call| @intFromEnum(call.function) < program.functions.len and type_id == program.functions[@intFromEnum(call.function)].output_type and check.typed(call.argument, program.functions[@intFromEnum(call.function)].input_type),
        .transform => |transform| check.transform(transform, type_id),
        .list_operation => |operation| check.operation(operation, target),
    };
}

const Check = struct {
    program: ir.Program,
    index: usize,
    fn earlier(self: Check, id: ir.ExprId) bool {
        return @intFromEnum(id) < self.index;
    }
    fn typed(self: Check, id: ir.ExprId, type_id: ir.TypeId) bool {
        return self.earlier(id) and self.program.expression(id).type_id == type_id;
    }

    fn binary(self: Check, value: @FieldType(@FieldType(ir.Expression, "value"), "binary"), result: ir.TypeId) bool {
        if (!self.earlier(value.left) or !self.earlier(value.right)) return false;

        const left = self.program.expression(value.left).type_id;
        const right = self.program.expression(value.right).type_id;
        const target = self.program.typeOf(left);

        if (value.operator == .coalesce) return target == .optional and target.optional == right and result == right;
        if (left != right) return false;
        if ((value.operator == .equal or value.operator == .not_equal) and target == .optional and !comparable(self.program, left) and self.program.expression(value.left).value != .none and self.program.expression(value.right).value != .none) return false;

        const numeric = numbers.isInteger(left) or numbers.isFloat(left);

        return switch (value.operator) {
            .logical_and, .logical_or => left == bool_type and result == bool_type,
            .equal, .not_equal => (numeric or left == bool_type or left == string_type or target == .enumeration or target == .optional) and result == bool_type,
            .less, .less_equal, .greater, .greater_equal => numeric and result == bool_type,
            else => numeric and result == left,
        };
    }

    fn transform(self: Check, value: ir.Transform, result: ir.TypeId) bool {
        if (!self.earlier(value.target) or !self.earlier(value.body)) return false;

        const source_id = self.program.expression(value.target).type_id;
        const source = self.program.typeOf(source_id);
        const target = self.program.typeOf(result);

        if (source != .list or value.parameters.len != @as(usize, if (value.kind == .reduce) 2 else 1)) return false;

        for (value.parameters, 0..) |parameter, index| {
            if (@intFromEnum(parameter) >= self.program.symbols.len) return false;
            if (self.program.symbols[@intFromEnum(parameter)].type_id != (if (value.kind == .reduce and index == 0) result else source.list)) return false;
        }

        return switch (value.kind) {
            .map => value.initial == null and target == .list and self.typed(value.body, target.list),
            .filter => value.initial == null and result == source_id and self.typed(value.body, bool_type),
            .reduce => value.initial != null and self.typed(value.initial.?, result) and self.typed(value.body, result),
        };
    }

    fn operation(self: Check, value: @FieldType(@FieldType(ir.Expression, "value"), "list_operation"), result: ir.Type) bool {
        if (!self.earlier(value.target) or result != .tuple or result.tuple.len != 2) return false;

        const source_id = self.program.expression(value.target).type_id;
        const source = self.program.typeOf(source_id);

        if (source != .list or result.tuple[0] != source_id) return false;

        const count: usize = switch (value.kind) {
            .push, .concat => 1,
            .splice => 3,
            else => 0,
        };

        if (value.arguments.len != count) return false;

        for (value.arguments, 0..) |argument, index| {
            const hint = switch (value.kind) {
                .push => source.list,
                .concat => source_id,
                .splice => if (index < 2) Types.scalarId(.u64) else source_id,
                else => unreachable,
            };

            if (!self.typed(argument, hint)) return false;
        }

        const business = self.program.typeOf(result.tuple[1]);

        return switch (value.kind) {
            .pop => business == .optional and business.optional == source.list,
            .splice => result.tuple[1] == source_id,
            .sort => result.tuple[1] == void_type and (numbers.isInteger(source.list) or numbers.isFloat(source.list) or source.list == string_type),
            else => result.tuple[1] == void_type,
        };
    }
};

fn comparable(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar => |scalar| scalar != .void,
        .enumeration => true,
        .optional => |child| comparable(program, child),
        else => false,
    };
}
