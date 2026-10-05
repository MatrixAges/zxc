const std = @import("std");
const ir = @import("zx").ir;

pub fn flat(program: ir.Program, id: ir.TypeId) bool {
    const target = program.typeOf(id);

    switch (target) {
        .object => |fields| for (fields) |field| {
            if (!leaf(program, field.type_id)) return false;
        },
        .tuple => |items| for (items) |item| {
            if (!leaf(program, item)) return false;
        },
        else => return false,
    }

    return true;
}

pub fn leaf(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration => true,
        .optional, .list => |child| leaf(program, child),
        else => false,
    };
}

pub fn pure(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, functions: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, iteration, functions, false);
}

pub fn deep(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, functions: []const bool) std.mem.Allocator.Error!bool {
    return analyze(allocator, program, iteration, functions, true);
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
        .optional => |child| supported(program, child),
        .object => |fields| blk: {
            for (fields) |field| if (!supported(program, field.type_id)) break :blk false;

            break :blk true;
        },
        .tuple => |items| blk: {
            for (items) |item| if (!supported(program, item)) break :blk false;

            break :blk true;
        },
        else => leaf(program, id),
    };
}

fn analyze(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, functions: []const bool, deep_layout: bool) std.mem.Allocator.Error!bool {
    const safe = try allocator.alloc(bool, program.expressions.len);

    defer allocator.free(safe);

    for (program.expressions, 0..) |expression, index| {
        if (deep_layout and (!supported(program, expression.type_id) or !deepOperation(program, expression))) {
            safe[index] = false;

            continue;
        }

        safe[index] = switch (expression.value) {
            .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .reference => true,
            .store_get => false,
            .some, .length => |child| safe[@backingInt(child)],
            .field, .tuple_field => |field| safe[@backingInt(field.target)],
            .index => |item| safe[@backingInt(item.target)] and safe[@backingInt(item.index)],
            .list, .tuple, .template => |items| all(safe, items),
            .list_operation => |item| safe[@backingInt(item.target)] and all(safe, item.arguments),
            .list_update => |item| safe[@backingInt(item.target)] and safe[@backingInt(item.index)] and safe[@backingInt(item.value)],
            .call => |item| @backingInt(item.function) < functions.len and functions[@backingInt(item.function)] and !program.functions[@backingInt(item.function)].consumes_input and safe[@backingInt(item.argument)],
            .unary => |item| safe[@backingInt(item.operand)],
            .binary => |item| safe[@backingInt(item.left)] and safe[@backingInt(item.right)],
            .conditional => |item| safe[@backingInt(item.condition)] and safe[@backingInt(item.yes)] and safe[@backingInt(item.no)],
            .transform => |item| safe[@backingInt(item.target)] and safe[@backingInt(item.body)] and (if (item.initial) |initial| safe[@backingInt(initial)] else true),
            .iteration => |item| safe[@backingInt(item.initial)] and safe[@backingInt(item.condition)] and safe[@backingInt(item.body)],
            .scope => |scope| scope_block: {
                for (scope.bindings) |binding| if (!safe[@backingInt(binding.value)]) break :scope_block false;

                break :scope_block safe[@backingInt(scope.result)];
            },
            .match_expr => |selection| match_block: {
                if (selection.subject) |subject| if (!safe[@backingInt(subject)]) break :match_block false;
                for (selection.arms) |arm| if (!safe[@backingInt(arm.condition)] or !safe[@backingInt(arm.result)]) break :match_block false;

                break :match_block safe[@backingInt(selection.fallback)];
            },
            .object => |object| object_block: {
                if (!all(safe, object.evaluation)) break :object_block false;
                for (object.fields) |field| if (!safe[@backingInt(field.value)]) break :object_block false;

                break :object_block true;
            },
        };
    }

    return safe[@backingInt(iteration.condition)] and safe[@backingInt(iteration.body)];
}

fn deepOperation(program: ir.Program, expression: ir.Expression) bool {
    return switch (expression.value) {
        .transform, .iteration => false,
        .call => |call| !represented(program, program.expression(call.argument).type_id) or !program.functions[@backingInt(call.function)].consumes_input,
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
