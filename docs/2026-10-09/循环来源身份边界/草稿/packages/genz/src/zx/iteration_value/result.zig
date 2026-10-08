const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Buffers = @import("../iteration_buffer/root.zig");
const consumer = @import("../iteration_consumer.zig");
const Self = @This();

allocator: std.mem.Allocator,
program: ir.Program,
cache: ?*const std.AutoHashMapUnmanaged(ir.ExprId, *const node.Expression) = null,
selected: consumer.Consumer,
projections: std.ArrayList(ir.ExprId) = .empty,
paths: std.ArrayList([]const usize) = .empty,
seen: std.AutoHashMapUnmanaged(ir.ExprId, void) = .empty,
pub fn eligible(lowering: *Lower, selected: consumer.Consumer) Lower.Error!bool {
    if (lowering.capture != null or primitive(lowering.program, lowering.program.expression(selected.result).type_id)) return false;

    var self = Self{ .allocator = lowering.allocator, .program = lowering.program, .cache = &lowering.cache, .selected = selected };

    return self.visit(selected.result);
}

pub fn candidate(allocator: std.mem.Allocator, program: ir.Program, selected: consumer.Consumer) Lower.Error!bool {
    const kind = program.typeOf(program.expression(selected.result).type_id);

    const scalar = switch (kind) {
        .scalar => |value| value != .string and value != .void,
        .enumeration, .error_set => true,
        else => false,
    };

    if (scalar) return consumer.projection(program, selected.result, selected.symbol);
    if (primitive(program, program.expression(selected.result).type_id)) return false;

    var self = Self{ .allocator = allocator, .program = program, .selected = selected };

    return self.visit(selected.result);
}

fn primitive(program: ir.Program, id: ir.TypeId) bool {
    return switch (program.typeOf(id)) {
        .scalar, .enumeration, .error_set, .native_reference => true,
        .optional => |child| primitive(program, child),
        else => false,
    };
}

fn visit(self: *Self, id: ir.ExprId) Lower.Error!bool {
    const program = self.program;
    const expression = program.expression(id);

    if (consumer.independent(program, id, self.selected.symbol)) return true;
    if (self.cache) |cache| if (cache.contains(id)) return false;
    if (self.seen.contains(id)) return true;
    try self.seen.put(self.allocator, id, {});

    if (primitive(program, expression.type_id) and consumer.projection(program, id, self.selected.symbol)) {
        try self.projections.append(self.allocator, id);

        return true;
    }

    switch (expression.value) {
        .object => |object| {
            for (object.evaluation) |child| if (!try self.visit(child)) return false;

            for (0..object.fields.len) |record_index| {
                const field = object.fields.at(record_index);

                if (!try self.visit(field.value)) return false;
            }
        },
        .tuple => |items| for (items) |child| {
            if (!try self.visit(child)) return false;
        },
        .field, .tuple_field, .reference => {
            const kind = program.typeOf(expression.type_id);

            if (kind != .list or !primitive(program, kind.list)) return false;

            var path: std.ArrayList(usize) = .empty;

            if (!try self.collectPath(id, &path)) return false;
            try self.paths.append(self.allocator, try path.toOwnedSlice(self.allocator));
            try self.projections.append(self.allocator, id);
        },
        .integer, .negative_integer, .float, .string, .boolean, .none, .unit, .enum_value, .error_value => {},
        else => return false,
    }

    return true;
}

fn collectPath(self: *Self, id: ir.ExprId, output: *std.ArrayList(usize)) Lower.Error!bool {
    return switch (self.program.expression(id).value) {
        .reference => |symbol| symbol == self.selected.symbol,
        .field, .tuple_field => |field| blk: {
            if (!try self.collectPath(field.target, output)) break :blk false;
            try output.append(self.allocator, field.index);

            break :blk true;
        },
        else => false,
    };
}

pub fn lower(lowering: *Lower, selected: consumer.Consumer, buffers: *const Buffers, body: *std.ArrayList(node.Statement), state: *const node.Expression, type_id: ir.TypeId) Lower.Error!*const node.Expression {
    if (primitive(lowering.program, lowering.program.expression(selected.result).type_id)) return consumer.read(lowering, selected, selected.result, state);

    var self = Self{ .allocator = lowering.allocator, .program = lowering.program, .cache = &lowering.cache, .selected = selected };
    const valid = try self.visit(selected.result);

    std.debug.assert(valid);

    for (buffers.fields.items) |field| {
        const exported = for (self.paths.items) |path_items| {
            if (std.mem.eql(usize, field.path, path_items)) break true;
        } else false;

        if (!exported) continue;

        var target = state;
        var current = type_id;

        for (field.path) |index| switch (lowering.program.typeOf(current)) {
            .object => |fields| {
                target = try lowering.field(target, fields.at(index).name);
                current = fields.at(index).type_id;
            },
            .tuple => |items| {
                target = try lowering.field(target, try std.fmt.allocPrint(lowering.allocator, "{d}", .{index}));
                current = items.at(index);
            },
            else => unreachable,
        };

        try field.storage.finish(lowering, body, target, lowering.types[@backingInt(field.element)]);
    }

    defer for (self.projections.items) |id| {
        _ = lowering.cache.remove(id);
    };

    for (self.projections.items) |id| try lowering.cache.put(lowering.allocator, id, try consumer.read(lowering, selected, id, state));

    return if (selected.layout) @import("../value_call/root.zig").expression(lowering, selected.result) else lowering.expr(selected.result);
}
