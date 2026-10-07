const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");
const Self = @This();

lowering: *Lower,
locals: []bool,
seen: []bool,
pub fn eligible(lowering: *Lower, iteration: ir.Iteration) Lower.Error!bool {
    const type_id = lowering.program.expression(iteration.initial).type_id;

    if (!supported(lowering.program, type_id)) return false;

    var path: std.ArrayList(usize) = .empty;
    var count: usize = 0;

    if (!try lists(lowering, iteration, type_id, &path, &count) or count == 0) return false;

    const locals = try lowering.allocator.alloc(bool, lowering.program.symbols.count());
    const seen = try lowering.allocator.alloc(bool, lowering.program.expressions.count());

    @memset(locals, false);
    @memset(seen, false);
    locals[@backingInt(iteration.parameter)] = true;
    locals[@backingInt(iteration.condition_parameter)] = true;

    var self = Self{ .lowering = lowering, .locals = locals, .seen = seen };

    return self.expression(iteration.condition) and self.expression(iteration.body);
}

pub fn product(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| product(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (!product(program, fields.at(index).type_id)) break :blk false;

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (!product(program, items.at(index))) break :blk false;

            break :blk true;
        },
        else => false,
    };
}

pub fn supported(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .list, .optional => |child| product(program, child),
        .object => |fields| blk: {
            for (0..fields.len) |index| if (!supported(program, fields.at(index).type_id)) break :blk false;

            break :blk true;
        },
        .tuple => |items| blk: {
            for (0..items.len) |index| if (!supported(program, items.at(index))) break :blk false;

            break :blk true;
        },
        else => product(program, id),
    };
}

fn lists(lowering: *Lower, iteration: ir.Iteration, id: ir.TypeId, path: *std.ArrayList(usize), count: *usize) Lower.Error!bool {
    switch (lowering.program.typeOf(id)) {
        .object => |fields| for (0..fields.len) |index| {
            try path.append(lowering.allocator, index);
            if (!try lists(lowering, iteration, fields.at(index).type_id, path, count)) return false;

            _ = path.pop();
        },
        .tuple => |items| for (0..items.len) |index| {
            try path.append(lowering.allocator, index);
            if (!try lists(lowering, iteration, items.at(index), path, count)) return false;

            _ = path.pop();
        },
        .list => |child| if (@import("../iteration_layout.zig").represented(lowering.program, child)) {
            const updates = try @import("../iteration_buffer/analysis.zig").analyze(lowering.allocator, lowering.program, iteration, path.items) orelse return false;

            for (updates) |update| if (lowering.list_update_buffers.contains(update) or lowering.collection_buffers.contains(update)) return false;

            count.* += 1;
        },
        else => {},
    }

    return true;
}

fn expression(self: *Self, id: ir.ExprId) bool {
    const index = @backingInt(id);

    if (self.seen[index]) return true;

    self.seen[index] = true;

    const program = self.lowering.program;
    const value = program.expression(id);

    if (!supported(program, value.type_id)) return false;
    if (self.lowering.cache.contains(id) and !primitive(program, value.type_id)) return false;

    return switch (value.value) {
        .reference => |symbol| self.locals[@backingInt(symbol)] or primitive(program, value.type_id),
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value => true,
        .field, .tuple_field => |field| self.expression(field.target),
        .some, .optional_value, .length => |child| self.expression(child),
        .index => |item| self.expression(item.target) and self.expression(item.index),
        .unary => |item| self.expression(item.operand),
        .binary => |item| blk: {
            const null_check = (item.operator == .equal or item.operator == .not_equal) and (program.expression(item.left).value == .none or program.expression(item.right).value == .none);
            const scalars = primitive(program, program.expression(item.left).type_id) and primitive(program, program.expression(item.right).type_id);

            break :blk (null_check or item.operator == .coalesce or scalars) and self.expression(item.left) and self.expression(item.right);
        },
        .conditional => |item| self.expression(item.condition) and self.expression(item.yes) and self.expression(item.no),
        .list, .tuple, .template => |items| self.all(items),
        .object => |object| blk: {
            if (!self.all(object.evaluation)) break :blk false;

            for (0..object.fields.len) |record_index| {
                const field = object.fields.at(record_index);

                if (!self.expression(field.value)) break :blk false;
            }

            break :blk true;
        },
        .scope => |scope| blk: {
            for (0..scope.bindings.len) |record_index| {
                const binding = scope.bindings.at(record_index);

                if (!self.expression(binding.value)) break :blk false;
                if (binding.symbol) |symbol| self.locals[@backingInt(symbol)] = true;
            }

            break :blk self.expression(scope.result);
        },
        .list_update => |item| self.expression(item.target) and self.expression(item.index) and self.expression(item.value),
        .list_operation => |item| (item.kind == .push or item.kind == .pop or item.kind == .concat) and self.expression(item.target) and self.all(item.arguments),
        .call => |call| blk: {
            const function = program.functions[@backingInt(call.function)];

            break :blk self.lowering.pure_functions[@backingInt(call.function)] and primitive(program, function.input_type) and primitive(program, function.output_type) and self.expression(call.argument);
        },
        .match_expr => |selection| blk: {
            if (selection.subject) |subject| if (!primitive(program, program.expression(subject).type_id) or !self.expression(subject)) break :blk false;

            for (0..selection.arms.len) |record_index| {
                const arm = selection.arms.at(record_index);

                if (!self.expression(arm.condition) or !self.expression(arm.result)) break :blk false;
            }

            break :blk self.expression(selection.fallback);
        },
        else => false,
    };
}

fn all(self: *Self, items: []const ir.ExprId) bool {
    for (items) |item| if (!self.expression(item)) return false;

    return true;
}

fn primitive(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| primitive(program, child),
        else => false,
    };
}
