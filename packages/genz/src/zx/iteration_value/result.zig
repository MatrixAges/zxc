const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const consumer = @import("../iteration_consumer.zig");
const Self = @This();

allocator: std.mem.Allocator,
program: ir.Program,
cache: ?*const @import("../expression_map.zig").Map(ir.ExprId) = null,
selected: consumer.Consumer,
projections: std.ArrayList(ir.ExprId) = .empty,
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

pub fn lower(lowering: *Lower, selected: consumer.Consumer, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (primitive(lowering.program, lowering.program.expression(selected.result).type_id)) return consumer.read(lowering, selected, selected.result, state);

    var self = Self{ .allocator = lowering.allocator, .program = lowering.program, .cache = &lowering.cache, .selected = selected };
    const valid = try self.visit(selected.result);

    std.debug.assert(valid);

    defer for (self.projections.items) |id| {
        _ = lowering.cache.remove(id);
    };

    for (self.projections.items) |id| try lowering.cache.put(lowering.allocator, id, try consumer.read(lowering, selected, id, state));

    return if (selected.layout) @import("../value_call/root.zig").expression(lowering, selected.result) else lowering.expr(selected.result);
}

pub fn buffered(context: *@import("root.zig"), body: *std.ArrayList(node.Statement), selected: consumer.Consumer, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    const lowering = context.lowering;
    const projection = @import("projection.zig");

    if (primitive(lowering.program, lowering.program.expression(selected.result).type_id)) return projection.read(context, selected, selected.result, state);

    var self = Self{ .allocator = lowering.allocator, .program = lowering.program, .cache = &lowering.cache, .selected = selected };

    std.debug.assert(try self.visit(selected.result));

    defer for (self.projections.items) |id| {
        _ = lowering.cache.remove(id);
    };

    const Transfer = struct { path: []const usize, value: node.ExpressionId };
    var transferred: std.ArrayList(Transfer) = .empty;

    for (self.projections.items) |id| {
        const type_id = lowering.program.expression(id).type_id;

        if (!context.buffered(type_id)) continue;

        const value = try projection.read(context, selected, id, state);
        var path: std.ArrayList(usize) = .empty;

        std.debug.assert(try self.collectPath(id, &path));

        const shared = for (transferred.items) |previous| {
            if (std.mem.eql(usize, previous.path, path.items)) break previous.value;
        } else null;

        const result = shared orelse try @import("transfer.zig").lower(context, body, type_id, value);

        if (shared == null) try transferred.append(lowering.allocator, .{ .path = path.items, .value = context.transfers.items[context.transfers.items.len - 1].value });

        try lowering.cache.put(lowering.allocator, id, result);
    }

    for (self.projections.items) |id| {
        if (context.buffered(lowering.program.expression(id).type_id)) continue;
        try lowering.cache.put(lowering.allocator, id, try projection.read(context, selected, id, state));
    }

    return if (selected.layout) @import("../value_call/root.zig").expression(lowering, selected.result) else lowering.expr(selected.result);
}
