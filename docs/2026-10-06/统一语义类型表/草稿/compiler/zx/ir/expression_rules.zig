const std = @import("std");
const ir = @import("zx").ir;
const Types = @import("../analysis/types.zig");
const numbers = @import("../analysis/numbers.zig");
const bool_type = Types.scalarId(.bool);
const string_type = Types.scalarId(.string);
const void_type = Types.scalarId(.void);

pub fn validate(program: ir.Program, expression: ir.Expression, index: usize) bool {
    const type_id = expression.type_id;

    if (@backingInt(type_id) >= program.types.count()) return false;

    const target = program.typeOf(type_id);
    const check = Check{ .program = program, .index = index };

    if (target == .task and expression.value != .task and expression.value != .reference) return false;

    return switch (expression.value) {
        .task => |task| blk: {
            if (target != .task or !check.typed(task.body, target.task.result)) break :blk false;

            for (task.captures, 0..) |symbol, capture_index| {
                if (@backingInt(symbol) >= program.symbols.len or program.typeOf(program.symbols[@backingInt(symbol)].type_id) == .task) break :blk false;
                if (std.mem.indexOfScalar(ir.SymbolId, task.captures[0..capture_index], symbol) != null) break :blk false;
            }

            break :blk true;
        },
        .await_task => |child| blk: {
            if (!check.earlier(child)) break :blk false;

            const task = program.typeOf(program.expression(child).type_id);

            break :blk task == .task and task.task.result == type_id;
        },
        .cancel_task => |child| check.earlier(child) and type_id == void_type and program.typeOf(program.expression(child).type_id) == .task,
        .parallel => |branches| blk: {
            if (target != .object and type_id != void_type) break :blk false;

            var fields: usize = 0;

            for (branches, 0..) |branch, branch_index| {
                if (!check.earlier(branch.task)) break :blk false;

                const task = program.expression(branch.task);

                if (task.value != .task or program.typeOf(task.type_id) != .task) break :blk false;

                const result = program.typeOf(task.type_id).task.result;

                if (branch.field) |field| {
                    if (target != .object or field >= target.object.len or target.object.at(field).type_id != result) break :blk false;

                    for (branches[0..branch_index]) |previous| if (previous.field == field) {
                        break :blk false;
                    };

                    fields += 1;
                } else if (result != void_type) break :blk false;

                for (branches[0..branch_index]) |previous| if (previous.task == branch.task) {
                    break :blk false;
                };
            }

            break :blk fields == (if (target == .object) target.object.len else @as(usize, 0));
        },
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
        .optional_value => |child| blk: {
            if (!check.earlier(child)) break :blk false;

            const optional = program.typeOf(program.expression(child).type_id);

            break :blk optional == .optional and optional.optional == type_id;
        },
        .capture => |child| blk: {
            if (!check.earlier(child) or target != .tuple or target.tuple.len != 2) break :blk false;

            const errors = program.typeOf(target.tuple.at(0));
            const result = program.typeOf(target.tuple.at(1));

            if (errors != .optional or program.typeOf(errors.optional) != .error_set) break :blk false;
            if (program.expression(child).type_id == void_type) break :blk target.tuple.at(1) == void_type;

            break :blk result == .optional and check.typed(child, result.optional);
        },
        .enum_value => |member| target == .enumeration and member < target.enumeration.members.len,
        .error_value => |member| target == .error_set and member < target.error_set.len,
        .store_get => |slot| slot < program.stores.len and program.stores[slot].readable and program.stores[slot].type_id == type_id,
        .reference => |symbol| @backingInt(symbol) < program.symbols.len and program.symbols[@backingInt(symbol)].type_id == type_id,
        .field, .tuple_field => |field| blk: {
            if (!check.earlier(field.target)) break :blk false;

            const base = program.typeOf(program.expression(field.target).type_id);

            break :blk if (expression.value == .field)
                base == .object and field.index < base.object.len and base.object.at(field.index).type_id == type_id

            else
                base == .tuple and field.index < base.tuple.len and base.tuple.at(field.index) == type_id;
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
        .list, .tuple => |items| blk: {
            if (expression.value == .list and target != .list) break :blk false;
            if (expression.value == .tuple and (target != .tuple or target.tuple.len != items.len)) break :blk false;

            for (items, 0..) |item, item_index| {
                if (!check.typed(item, if (target == .list) target.list else target.tuple.at(item_index))) break :blk false;
            }

            break :blk true;
        },
        .object => |object| blk: {
            if (target != .object or target.object.len != object.fields.len) break :blk false;

            for (object.evaluation) |item| if (!check.earlier(item) or program.typeOf(program.expression(item).type_id) == .task) {
                break :blk false;
            };

            for (object.fields, 0..) |field, field_index| {
                if (field.index >= target.object.len or !check.typed(field.value, target.object.at(field.index).type_id)) break :blk false;

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
        .match_expr => |selection| blk: {
            var condition_type = bool_type;

            if (selection.subject) |subject| {
                if (!check.earlier(subject)) break :blk false;

                condition_type = program.expression(subject).type_id;
                const subject_type = program.typeOf(condition_type);

                if ((subject_type != .scalar and subject_type != .enumeration and subject_type != .error_set) or condition_type == void_type) break :blk false;
            }

            for (selection.arms) |arm| {
                if (!check.typed(arm.condition, condition_type) or !check.typed(arm.result, type_id)) break :blk false;
            }

            break :blk check.typed(selection.fallback, type_id);
        },
        .call => |call| @backingInt(call.function) < program.functions.len and type_id == program.functions[@backingInt(call.function)].output_type and check.typed(call.argument, program.functions[@backingInt(call.function)].input_type) and @import("stores.zig").call(program, call),
        .transform => |transform| check.transform(transform, type_id),
        .list_update => |update| target == .list and check.typed(update.target, type_id) and check.typed(update.index, Types.scalarId(.u64)) and check.typed(update.value, target.list),
        .iteration => |iteration| type_id != void_type and check.typed(iteration.initial, type_id) and check.typed(iteration.body, type_id) and check.typed(iteration.condition, bool_type) and
            iteration.parameter != iteration.condition_parameter and

            @backingInt(iteration.parameter) < program.symbols.len and @backingInt(iteration.condition_parameter) < program.symbols.len and
            program.symbols[@backingInt(iteration.parameter)].type_id == type_id and program.symbols[@backingInt(iteration.condition_parameter)].type_id == type_id,
        .scope => |scope| blk: {
            for (scope.bindings) |binding| {
                if (!check.earlier(binding.value)) break :blk false;

                if (binding.symbol) |symbol| {
                    if (@backingInt(symbol) >= program.symbols.len or !check.typed(binding.value, program.symbols[@backingInt(symbol)].type_id)) break :blk false;
                } else if (!check.typed(binding.value, void_type)) break :blk false;
            }

            break :blk check.typed(scope.result, type_id);
        },
        .list_operation => |operation| check.operation(operation, target),
    };
}

const Check = struct {
    program: ir.Program,
    index: usize,
    fn earlier(self: Check, id: ir.ExprId) bool {
        return @backingInt(id) < self.index;
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
            .equal, .not_equal => (numeric or left == bool_type or left == string_type or target == .enumeration or target == .error_set or target == .optional) and result == bool_type,
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
            if (@backingInt(parameter) >= self.program.symbols.len) return false;
            if (self.program.symbols[@backingInt(parameter)].type_id != (if (value.kind == .reduce and index == 0) result else source.list)) return false;
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

        if (source != .list or result.tuple.at(0) != source_id) return false;

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

        const business = self.program.typeOf(result.tuple.at(1));

        return switch (value.kind) {
            .pop => business == .optional and business.optional == source.list,
            .splice => result.tuple.at(1) == source_id,
            .sort => result.tuple.at(1) == void_type and (numbers.isInteger(source.list) or numbers.isFloat(source.list) or source.list == string_type),
            else => result.tuple.at(1) == void_type,
        };
    }
};

fn comparable(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar => |scalar| scalar != .void,
        .enumeration, .error_set => true,
        .optional => |child| comparable(program, child),
        else => false,
    };
}
