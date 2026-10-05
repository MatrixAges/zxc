const std = @import("std");
const ir = @import("zx").ir;
const Error = @import("builder.zig").Error;
const Self = @This();

allocator: std.mem.Allocator,
symbols: []?ir.SymbolId,
expressions: []?ir.ExprId,
pub fn id(self: *const Self, value: ir.ExprId) Error!ir.ExprId {
    if (@backingInt(value) >= self.expressions.len) return error.InvalidModule;

    return self.expressions[@backingInt(value)] orelse error.InvalidModule;
}

fn symbol(self: *const Self, value: ir.SymbolId) Error!ir.SymbolId {
    if (@backingInt(value) >= self.symbols.len) return error.InvalidModule;

    return self.symbols[@backingInt(value)] orelse error.InvalidModule;
}

fn ids(self: *const Self, values: []const ir.ExprId) Error![]const ir.ExprId {
    const result = try self.allocator.alloc(ir.ExprId, values.len);

    for (values, result) |value, *item| item.* = try self.id(value);

    return result;
}

pub fn expression(self: *const Self, value: ir.Expression) Error!ir.Expression {
    var result = value;

    result.value = switch (value.value) {
        .integer, .negative_integer, .float, .boolean, .none, .unit, .enum_value, .error_value => value.value,
        .string => |text| .{ .string = try self.allocator.dupe(u8, text) },
        .reference => |source| .{ .reference = try self.symbol(source) },
        .some => |child| .{ .some = try self.id(child) },
        .length => |child| .{ .length = try self.id(child) },
        .field => |field| .{ .field = .{ .target = try self.id(field.target), .index = field.index } },
        .tuple_field => |field| .{ .tuple_field = .{ .target = try self.id(field.target), .index = field.index } },
        .index => |item| .{ .index = .{ .target = try self.id(item.target), .index = try self.id(item.index) } },
        .list => |items| .{ .list = try self.ids(items) },
        .tuple => |items| .{ .tuple = try self.ids(items) },
        .template => |items| .{ .template = try self.ids(items) },
        .list_update => |update| .{ .list_update = .{ .target = try self.id(update.target), .index = try self.id(update.index), .value = try self.id(update.value) } },
        .iteration => |item| .{ .iteration = .{
            .initial = try self.id(item.initial),
            .condition_parameter = try self.symbol(item.condition_parameter),
            .parameter = try self.symbol(item.parameter),
            .condition = try self.id(item.condition),
            .body = try self.id(item.body),
            .postcondition = item.postcondition,
        } },
        .scope => |scope| block: {
            const bindings = try self.allocator.alloc(ir.ScopeBinding, scope.bindings.len);

            for (scope.bindings, bindings) |binding, *mapped| mapped.* = .{
                .symbol = if (binding.symbol) |source| try self.symbol(source) else null,
                .value = try self.id(binding.value),
                .borrow = binding.borrow,
            };

            break :block .{ .scope = .{ .bindings = bindings, .result = try self.id(scope.result) } };
        },
        .optional_value => |child| .{ .optional_value = try self.id(child) },
        .capture => |child| .{ .capture = try self.id(child) },
        .unary => |item| .{ .unary = .{ .operator = item.operator, .operand = try self.id(item.operand) } },
        .binary => |item| .{ .binary = .{ .operator = item.operator, .left = try self.id(item.left), .right = try self.id(item.right) } },
        .conditional => |item| .{ .conditional = .{ .condition = try self.id(item.condition), .yes = try self.id(item.yes), .no = try self.id(item.no) } },
        .list_operation => |item| .{ .list_operation = .{ .kind = item.kind, .target = try self.id(item.target), .arguments = try self.ids(item.arguments) } },
        .transform => |item| block: {
            const parameters = try self.allocator.alloc(ir.SymbolId, item.parameters.len);

            for (item.parameters, parameters) |parameter, *mapped| mapped.* = try self.symbol(parameter);

            break :block .{ .transform = .{ .kind = item.kind, .target = try self.id(item.target), .parameters = parameters, .body = try self.id(item.body), .initial = if (item.initial) |initial| try self.id(initial) else null } };
        },
        .match_expr => |item| block: {
            const arms = try self.allocator.alloc(ir.MatchArm, item.arms.len);

            for (item.arms, arms) |arm, *mapped| mapped.* = .{ .condition = try self.id(arm.condition), .result = try self.id(arm.result) };

            break :block .{ .match_expr = .{ .subject = if (item.subject) |subject| try self.id(subject) else null, .arms = arms, .fallback = try self.id(item.fallback) } };
        },
        .object => |item| block: {
            const fields = try self.allocator.alloc(ir.ObjectField, item.fields.len);

            for (item.fields, fields) |field, *mapped| mapped.* = .{ .index = field.index, .value = try self.id(field.value) };

            break :block .{ .object = .{ .fields = fields, .evaluation = try self.ids(item.evaluation) } };
        },
        .store_get, .call => return error.InvalidModule,
    };

    return result;
}
