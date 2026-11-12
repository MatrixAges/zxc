const std = @import("std");
const ir = @import("zx").ir;
const Error = @import("builder.zig").Error;
const missing = @import("linking.zig").missing;
const Self = @This();

allocator: std.mem.Allocator,
bindings: []const u32,
locals_base: usize,
symbol_count: usize,
expressions: []const u32,

available: usize = 0,
pub fn id(self: *const Self, value: ir.ExprId) Error!ir.ExprId {
    const index = @backingInt(value);

    if (index >= self.available) return error.InvalidModule;

    const target = self.expressions[index];

    return if (target == missing) error.InvalidModule else @fromBackingInt(target);
}

pub fn symbol(self: *const Self, value: ir.SymbolId) Error!ir.SymbolId {
    const index = @backingInt(value);

    if (index == 0 or index >= self.symbol_count) return error.InvalidModule;

    const offset = index - 1;

    if (offset >= self.bindings.len) return @fromBackingInt(@intCast(self.locals_base + (offset - self.bindings.len)));

    const target = self.bindings[offset];

    return if (target == missing) error.InvalidModule else @fromBackingInt(target);
}

pub fn expression(self: *const Self, value: ir.ExpressionRow) Error!ir.Expression {
    var result: ir.Expression = .{ .type_id = value.type_id, .span = value.span, .value = undefined };

    result.value = switch (value.value) {
        inline .integer, .negative_integer, .float, .boolean, .none, .unit, .enum_value, .error_value => |item, tag| @unionInit(@FieldType(ir.Expression, "value"), @tagName(tag), item),
        .string => |text| .{ .string = try self.allocator.dupe(u8, text) },
        .reference => |source| .{ .reference = try self.symbol(source) },
        .some => |child| .{ .some = try self.id(child) },
        .length => |child| .{ .length = try self.id(child) },
        .field => |field| .{ .field = .{ .target = try self.id(field.target), .index = field.index } },
        .tuple_field => |field| .{ .tuple_field = .{ .target = try self.id(field.target), .index = field.index } },
        .index => |item| .{ .index = .{ .target = try self.id(item.target), .index = try self.id(item.index) } },
        .list_update => |update| .{ .list_update = .{ .target = try self.id(update.target), .index = try self.id(update.index), .value = try self.id(update.value) } },
        .iteration => |item| .{ .iteration = .{
            .environment_symbol = if (item.environment_symbol) |source| try self.symbol(source) else null,
            .initial = try self.id(item.initial),
            .condition_parameter = try self.symbol(item.condition_parameter),
            .parameter = try self.symbol(item.parameter),
            .condition = try self.id(item.condition),
            .body = try self.id(item.body),
            .postcondition = item.postcondition,
        } },
        .optional_value => |child| .{ .optional_value = try self.id(child) },
        .capture => |child| .{ .capture = try self.id(child) },
        .unary => |item| .{ .unary = .{ .operator = item.operator, .operand = try self.id(item.operand) } },
        .binary => |item| .{ .binary = .{ .operator = item.operator, .left = try self.id(item.left), .right = try self.id(item.right) } },
        .conditional => |item| .{ .conditional = .{ .condition = try self.id(item.condition), .yes = try self.id(item.yes), .no = try self.id(item.no) } },
        .list, .tuple, .template, .list_operation, .transform, .scope, .match_expr, .object => unreachable,
        .store_get, .call, .task, .await_task, .cancel_task, .parallel => return error.InvalidModule,
    };

    return result;
}
