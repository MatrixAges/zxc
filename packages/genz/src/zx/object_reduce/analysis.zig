const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

program: ir.Program,
accumulator: ir.SymbolId,
safe: []const bool,
value_functions: []const bool,

has_object: bool = false,
pub fn accepts(allocator: std.mem.Allocator, program: ir.Program, transform: ir.Transform, value_functions: []const bool) std.mem.Allocator.Error!bool {
    const safe = try allocator.alloc(bool, program.expressions.count());

    defer allocator.free(safe);

    for (0..program.expressions.count()) |index| {
        const expression = program.expressions.at(index);

        safe[index] = switch (expression.value) {
            .scope, .iteration, .list_update, .capture, .task, .await_task, .cancel_task, .parallel => false,
            .reference => |symbol| symbol != transform.parameters[0],
            .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value, .store_get => true,
            .some, .optional_value, .length => |id| safe[@backingInt(id)],
            .field => |field| direct(program, field.target, transform.parameters[0]) or safe[@backingInt(field.target)],
            .tuple_field => |field| safe[@backingInt(field.target)],
            .index => |value| safe[@backingInt(value.target)] and safe[@backingInt(value.index)],
            .list, .tuple, .template => |values| all(safe, values),
            .list_operation => |value| safe[@backingInt(value.target)] and all(safe, value.arguments),
            .transform => |value| safe[@backingInt(value.target)] and safe[@backingInt(value.body)] and (if (value.initial) |initial| safe[@backingInt(initial)] else true),
            .call => |value| safe[@backingInt(value.argument)],
            .unary => |value| safe[@backingInt(value.operand)],
            .binary => |value| safe[@backingInt(value.left)] and safe[@backingInt(value.right)],
            .conditional => |value| safe[@backingInt(value.condition)] and safe[@backingInt(value.yes)] and safe[@backingInt(value.no)],
            .match_expr => |value| blk: {
                if (value.subject) |subject| if (!safe[@backingInt(subject)]) break :blk false;
                if (!safe[@backingInt(value.fallback)]) break :blk false;

                for (0..value.arms.len) |record_index| {
                    const arm = value.arms.at(record_index);

                    if (!safe[@backingInt(arm.condition)] or !safe[@backingInt(arm.result)]) break :blk false;
                }

                break :blk true;
            },
            .object => |value| blk: {
                if (!all(safe, value.evaluation)) break :blk false;

                for (0..value.fields.len) |record_index| {
                    const field = value.fields.at(record_index);

                    if (!safe[@backingInt(field.value)]) break :blk false;
                }

                break :blk true;
            },
        };
    }

    var self = Self{ .program = program, .accumulator = transform.parameters[0], .safe = safe, .value_functions = value_functions };

    return self.result(transform.body) and self.has_object;
}

fn result(self: *Self, id: ir.ExprId) bool {
    return switch (self.program.expression(id).value) {
        .reference => |symbol| symbol == self.accumulator,
        .conditional => |value| self.safe[@backingInt(value.condition)] and self.result(value.yes) and self.result(value.no),
        .match_expr => |value| blk: {
            if (value.subject) |subject| if (!self.safe[@backingInt(subject)]) break :blk false;

            for (0..value.arms.len) |index| {
                const arm = value.arms.at(index);

                if (!self.safe[@backingInt(arm.condition)] or !self.result(arm.result)) break :blk false;
            }

            break :blk self.result(value.fallback);
        },
        .call => |value| blk: {
            if (!self.value_functions[@backingInt(value.function)] or !self.argument(value.argument)) break :blk false;

            self.has_object = true;

            break :blk true;
        },
        .object => |value| blk: {
            for (value.evaluation) |item| if (!self.safe[@backingInt(item)] and !direct(self.program, item, self.accumulator)) break :blk false;

            for (0..value.fields.len) |record_index| {
                const field = value.fields.at(record_index);

                if (!self.safe[@backingInt(field.value)]) break :blk false;
            }

            self.has_object = true;

            break :blk true;
        },
        else => false,
    };
}

fn argument(self: *const Self, id: ir.ExprId) bool {
    if (self.safe[@backingInt(id)]) return true;

    return switch (self.program.expression(id).value) {
        .reference => |symbol| symbol == self.accumulator,
        .object => |value| blk: {
            for (value.evaluation) |item| if (!self.argument(item)) break :blk false;

            for (0..value.fields.len) |record_index| {
                const field = value.fields.at(record_index);

                if (!self.argument(field.value)) break :blk false;
            }

            break :blk true;
        },
        .conditional => |value| self.safe[@backingInt(value.condition)] and self.argument(value.yes) and self.argument(value.no),
        .match_expr => |value| blk: {
            if (value.subject) |subject| if (!self.safe[@backingInt(subject)]) break :blk false;

            for (0..value.arms.len) |index| {
                const arm = value.arms.at(index);

                if (!self.safe[@backingInt(arm.condition)] or !self.argument(arm.result)) break :blk false;
            }

            break :blk self.argument(value.fallback);
        },
        else => false,
    };
}

fn direct(program: ir.Program, id: ir.ExprId, symbol: ir.SymbolId) bool {
    const value = program.expression(id).value;

    return value == .reference and value.reference == symbol;
}

fn all(safe: []const bool, values: []const ir.ExprId) bool {
    for (values) |value| if (!safe[@backingInt(value)]) return false;

    return true;
}
