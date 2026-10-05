const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

program: ir.Program,
accumulator: ir.SymbolId,
safe: []const bool,
value_functions: []const bool,

has_object: bool = false,
pub fn accepts(allocator: std.mem.Allocator, program: ir.Program, transform: ir.Transform, value_functions: []const bool) std.mem.Allocator.Error!bool {
    const safe = try allocator.alloc(bool, program.expressions.len);

    defer allocator.free(safe);

    for (program.expressions, 0..) |expression, index| {
        safe[index] = switch (expression.value) {
            .reference => |symbol| symbol != transform.parameters[0],
            .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .store_get => true,
            .some, .length => |id| safe[@intFromEnum(id)],
            .field => |field| direct(program, field.target, transform.parameters[0]) or safe[@intFromEnum(field.target)],
            .tuple_field => |field| safe[@intFromEnum(field.target)],
            .index => |value| safe[@intFromEnum(value.target)] and safe[@intFromEnum(value.index)],
            .list, .tuple, .template => |values| all(safe, values),
            .list_operation => |value| safe[@intFromEnum(value.target)] and all(safe, value.arguments),
            .transform => |value| safe[@intFromEnum(value.target)] and safe[@intFromEnum(value.body)] and (if (value.initial) |initial| safe[@intFromEnum(initial)] else true),
            .call => |value| safe[@intFromEnum(value.argument)],
            .unary => |value| safe[@intFromEnum(value.operand)],
            .binary => |value| safe[@intFromEnum(value.left)] and safe[@intFromEnum(value.right)],
            .conditional => |value| safe[@intFromEnum(value.condition)] and safe[@intFromEnum(value.yes)] and safe[@intFromEnum(value.no)],
            .match_expr => |value| blk: {
                if (value.subject) |subject| if (!safe[@intFromEnum(subject)]) break :blk false;
                if (!safe[@intFromEnum(value.fallback)]) break :blk false;
                for (value.arms) |arm| if (!safe[@intFromEnum(arm.condition)] or !safe[@intFromEnum(arm.result)]) break :blk false;

                break :blk true;
            },
            .object => |value| blk: {
                if (!all(safe, value.evaluation)) break :blk false;
                for (value.fields) |field| if (!safe[@intFromEnum(field.value)]) break :blk false;

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
        .conditional => |value| self.safe[@intFromEnum(value.condition)] and self.result(value.yes) and self.result(value.no),
        .call => |value| blk: {
            if (!self.value_functions[@intFromEnum(value.function)] or !self.argument(value.argument)) break :blk false;

            self.has_object = true;

            break :blk true;
        },
        .object => |value| blk: {
            for (value.evaluation) |item| if (!self.safe[@intFromEnum(item)] and !direct(self.program, item, self.accumulator)) break :blk false;
            for (value.fields) |field| if (!self.safe[@intFromEnum(field.value)]) break :blk false;

            self.has_object = true;

            break :blk true;
        },
        else => false,
    };
}

fn argument(self: *const Self, id: ir.ExprId) bool {
    if (self.safe[@intFromEnum(id)]) return true;

    return switch (self.program.expression(id).value) {
        .reference => |symbol| symbol == self.accumulator,
        .object => |value| blk: {
            for (value.evaluation) |item| if (!self.argument(item)) break :blk false;
            for (value.fields) |field| if (!self.argument(field.value)) break :blk false;

            break :blk true;
        },
        .conditional => |value| self.safe[@intFromEnum(value.condition)] and self.argument(value.yes) and self.argument(value.no),
        else => false,
    };
}

fn direct(program: ir.Program, id: ir.ExprId, symbol: ir.SymbolId) bool {
    const value = program.expression(id).value;

    return value == .reference and value.reference == symbol;
}

fn all(safe: []const bool, values: []const ir.ExprId) bool {
    for (values) |value| if (!safe[@intFromEnum(value)]) return false;

    return true;
}
