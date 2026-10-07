const std = @import("std");
const ir = @import("zx").ir;

pub fn flat(program: ir.Program, id: ir.TypeId) bool {
    const target = program.typeOf(id);

    switch (target) {
        .object => |fields| for (0..fields.len) |view_index| {
            const field = fields.at(view_index);

            if (!leaf(program, field.type_id)) return false;
        },
        .tuple => |items| for (0..items.len) |item_index| {
            const item = items.at(item_index);

            if (!leaf(program, item)) return false;
        },
        else => return false,
    }

    return true;
}

pub fn leaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional, .list => |child| leaf(program, child),
        else => false,
    };
}

pub fn eligible(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, functions: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{ iteration.condition, iteration.body }, functions, false);
}

pub fn condition(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, functions: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{iteration.condition}, functions, false);
}

pub fn deep(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, functions: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{ iteration.condition, iteration.body }, functions, true);
}

pub fn initialValue(allocator: std.mem.Allocator, program: ir.Program, value: ir.ExprId, functions: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, &.{value}, functions, true);
}

pub fn aggregate(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .object, .tuple => true,
        else => false,
    };
}

pub fn represented(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .optional => |child| represented(program, child),
        else => aggregate(program, id),
    };
}

pub fn supported(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list => true,
        .optional => |child| supported(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |view_index| {
                const field = fields.at(view_index);

                if (!supported(program, field.type_id)) break :blk false;
            }

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |item_index| {
                const item = items.at(item_index);

                if (!supported(program, item)) break :blk false;
            }

            break :blk true;
        },
        else => leaf(program, id),
    };
}

fn analyze(allocator: std.mem.Allocator, program: ir.Program, roots: []const ir.ExprId, functions: []const bool, deep_layout: bool) std.mem.Allocator.Error!bool {
    const safe = try allocator.alloc(bool, program.expressions.count());

    defer allocator.free(safe);

    for (0..program.expressions.count()) |index| {
        const expression = program.expressions.at(index);

        if (deep_layout and (!supported(program, expression.type_id) or !deepOperation(program, expression))) {
            safe[index] = false;

            continue;
        }

        safe[index] = switch (expression.value) {
            .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value, .reference => true,
            .store_get, .capture, .task, .await_task, .cancel_task, .parallel => false,
            .some, .optional_value, .length => |child| safe[@backingInt(child)],
            .field, .tuple_field => |field| safe[@backingInt(field.target)],
            .index => |item| safe[@backingInt(item.target)] and safe[@backingInt(item.index)],
            .list, .tuple, .template => |items| all(safe, items),
            .list_operation => |item| safe[@backingInt(item.target)] and all(safe, item.arguments),
            .list_update => |item| safe[@backingInt(item.target)] and safe[@backingInt(item.index)] and safe[@backingInt(item.value)],
            .call => |item| @backingInt(item.function) < functions.len and functions[@backingInt(item.function)] and safe[@backingInt(item.argument)],
            .unary => |item| safe[@backingInt(item.operand)],
            .binary => |item| safe[@backingInt(item.left)] and safe[@backingInt(item.right)],
            .conditional => |item| safe[@backingInt(item.condition)] and safe[@backingInt(item.yes)] and safe[@backingInt(item.no)],
            .transform => |item| safe[@backingInt(item.target)] and safe[@backingInt(item.body)] and (if (item.initial) |initial| safe[@backingInt(initial)] else true),
            .iteration => |item| safe[@backingInt(item.initial)] and safe[@backingInt(item.condition)] and safe[@backingInt(item.body)],
            .scope => |scope| scope_block: {
                for (0..scope.bindings.len) |record_index| {
                    const binding = scope.bindings.at(record_index);

                    if (!safe[@backingInt(binding.value)]) break :scope_block false;
                }

                break :scope_block safe[@backingInt(scope.result)];
            },
            .match_expr => |selection| match_block: {
                if (selection.subject) |subject| if (!safe[@backingInt(subject)]) break :match_block false;

                for (0..selection.arms.len) |record_index| {
                    const arm = selection.arms.at(record_index);

                    if (!safe[@backingInt(arm.condition)] or !safe[@backingInt(arm.result)]) break :match_block false;
                }

                break :match_block safe[@backingInt(selection.fallback)];
            },
            .object => |object| object_block: {
                if (!all(safe, object.evaluation)) break :object_block false;

                for (0..object.fields.len) |record_index| {
                    const field = object.fields.at(record_index);

                    if (!safe[@backingInt(field.value)]) break :object_block false;
                }

                break :object_block true;
            },
        };
    }

    return all(safe, roots);
}

fn deepOperation(program: ir.Program, expression: ir.ExpressionRow) bool {
    return switch (expression.value) {
        .transform, .iteration => false,
        .list => !represented(program, program.typeOf(expression.type_id).list),
        .list_update => |update| !represented(program, program.expression(update.value).type_id),
        .list_operation => |operation| !represented(program, program.typeOf(program.expression(operation.target).type_id).list),
        .call => |call| blk: {
            const function = program.functions.at(@backingInt(call.function));

            break :blk !listEscape(program, function.input_type, function.output_type);
        },
        .binary => |binary| binary.operator == .coalesce or
            ((binary.operator == .equal or binary.operator == .not_equal) and (program.expression(binary.left).value == .none or program.expression(binary.right).value == .none)) or
            (!represented(program, program.expression(binary.left).type_id) and !represented(program, program.expression(binary.right).type_id)),
        .match_expr => |selection| if (selection.subject) |subject| !represented(program, program.expression(subject).type_id) else true,
        else => true,
    };
}

fn all(safe: []const bool, items: []const ir.ExprId) bool {
    for (items) |item| if (!safe[@backingInt(item)]) return false;

    return true;
}

fn listEscape(program: ir.Program, input: ir.TypeId, output: ir.TypeId) bool {
    return switch (program.typeOf(output)) {
        .list => |child| borrowedProduct(program, input, child),
        .optional => |child| listEscape(program, input, child),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (listEscape(program, input, fields.at(index).type_id)) break :blk true;

            break :blk false;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (listEscape(program, input, items.at(index))) break :blk true;

            break :blk false;
        },
        else => false,
    };
}

fn borrowedProduct(program: ir.Program, input: ir.TypeId, output: ir.TypeId) bool {
    const kind = program.typeOf(input);

    if ((kind == .object or kind == .tuple) and (input == output or @import("value_call/analysis.zig").containsDescendant(program, output, input))) return true;

    return switch (kind) {
        .optional => |child| borrowedProduct(program, child, output),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (borrowedProduct(program, fields.at(index).type_id, output)) break :blk true;

            break :blk false;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (borrowedProduct(program, items.at(index), output)) break :blk true;

            break :blk false;
        },
        else => false,
    };
}
