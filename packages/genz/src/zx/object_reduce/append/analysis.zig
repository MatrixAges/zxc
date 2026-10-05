const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

allocator: std.mem.Allocator,
program: ir.Program,
accumulator: ir.SymbolId,
field_index: u32,
safe: []const bool,
projections: std.ArrayList(ir.ExprId) = .empty,
pub fn analyze(allocator: std.mem.Allocator, program: ir.Program, transform: ir.Transform, field_index: u32) std.mem.Allocator.Error!?[]const ir.ExprId {
    const safe = try allocator.alloc(bool, program.expressions.len);

    defer allocator.free(safe);

    var self = Self{ .allocator = allocator, .program = program, .accumulator = transform.parameters[0], .field_index = field_index, .safe = safe };

    defer self.projections.deinit(allocator);

    for (program.expressions, 0..) |expression, index| safe[index] = self.read(expression.value);
    if (!try self.result(transform.body) or self.projections.items.len == 0) return null;

    return try self.projections.toOwnedSlice(allocator);
}

fn read(self: Self, value: @FieldType(ir.Expression, "value")) bool {
    const safe = self.safe;

    return switch (value) {
        .scope, .iteration, .list_update => false,
        .reference => |symbol| symbol != self.accumulator,
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .store_get => true,
        .some => |id| safe[@backingInt(id)],
        .length => |id| self.field(id) or safe[@backingInt(id)],
        .field => |item| if (self.direct(item.target)) item.index != self.field_index else safe[@backingInt(item.target)],
        .tuple_field => |item| safe[@backingInt(item.target)],
        .index => |item| safe[@backingInt(item.target)] and safe[@backingInt(item.index)],
        .list, .tuple, .template => |items| all(safe, items),
        .list_operation => |item| safe[@backingInt(item.target)] and all(safe, item.arguments),
        .transform => |item| safe[@backingInt(item.target)] and safe[@backingInt(item.body)] and (if (item.initial) |initial| safe[@backingInt(initial)] else true),
        .call => |item| safe[@backingInt(item.argument)],
        .unary => |item| safe[@backingInt(item.operand)],
        .binary => |item| safe[@backingInt(item.left)] and safe[@backingInt(item.right)],
        .conditional => |item| safe[@backingInt(item.condition)] and safe[@backingInt(item.yes)] and safe[@backingInt(item.no)],
        .match_expr => |item| blk: {
            if (item.subject) |subject| if (!safe[@backingInt(subject)]) break :blk false;
            if (!safe[@backingInt(item.fallback)]) break :blk false;
            for (item.arms) |arm| if (!safe[@backingInt(arm.condition)] or !safe[@backingInt(arm.result)]) break :blk false;

            break :blk true;
        },
        .object => |item| blk: {
            if (!all(safe, item.evaluation)) break :blk false;
            for (item.fields) |entry| if (!safe[@backingInt(entry.value)]) break :blk false;

            break :blk true;
        },
    };
}

fn result(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!bool {
    return switch (self.program.expression(id).value) {
        .reference => |symbol| symbol == self.accumulator,
        .conditional => |value| self.safe[@backingInt(value.condition)] and try self.result(value.yes) and try self.result(value.no),
        .object => |value| blk: {
            const selected = for (value.fields) |item| {
                if (item.index == self.field_index) break item.value;
            } else break :blk false;

            if (!try self.append(selected)) break :blk false;

            for (value.fields) |item| if (item.index != self.field_index and !self.safe[@backingInt(item.value)]) break :blk false;

            for (value.evaluation) |item| {
                if (item == selected or self.safe[@backingInt(item)] or self.direct(item) or self.field(item)) continue;

                break :blk false;
            }

            break :blk true;
        },
        else => false,
    };
}

fn append(self: *Self, id: ir.ExprId) std.mem.Allocator.Error!bool {
    if (self.field(id)) return true;

    return switch (self.program.expression(id).value) {
        .conditional => |value| self.safe[@backingInt(value.condition)] and try self.append(value.yes) and try self.append(value.no),
        .tuple_field => |projection| blk: {
            const value = self.program.expression(projection.target).value;

            if (projection.index != 0 or value != .list_operation) break :blk false;

            const operation = value.list_operation;

            if ((operation.kind != .push and operation.kind != .concat) or !self.field(operation.target) or !all(self.safe, operation.arguments)) break :blk false;
            if (std.mem.indexOfScalar(ir.ExprId, self.projections.items, id) == null) try self.projections.append(self.allocator, id);

            break :blk true;
        },
        else => false,
    };
}

fn direct(self: Self, id: ir.ExprId) bool {
    const value = self.program.expression(id).value;

    return value == .reference and value.reference == self.accumulator;
}

fn field(self: Self, id: ir.ExprId) bool {
    const value = self.program.expression(id).value;

    return value == .field and value.field.index == self.field_index and self.direct(value.field.target);
}

fn all(safe: []const bool, ids: []const ir.ExprId) bool {
    for (ids) |id| if (!safe[@backingInt(id)]) return false;

    return true;
}
