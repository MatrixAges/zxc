const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const operands = @import("../aggregate/operands.zig");

pub fn borrow(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId) Lower.Error!node.ExpressionId {
    if (self.cache.contains(id)) return existing(self, body, id);

    const expression = self.program.expression(id);

    switch (expression.value) {
        .object => return object(self, body, id),
        .tuple => |items| {
            const values = try self.allocator.alloc(node.ExpressionId, items.len);

            for (items, values) |item, *value| value.* = try aggregate.bind(self, body, try borrow(self, body, item));

            const value = try aggregate.bind(self, body, try self.cast(try @import("../types.zig").get(self, self.abi_layouts, expression.type_id), try self.builder.expression(.{ .tuple = values })));

            return self.builder.expression(.{ .address_of = value });
        },
        .call => |invocation| {
            if (!self.value_functions[@backingInt(invocation.function)] or !self.constructed_outputs[@backingInt(invocation.function)]) return existing(self, body, id);

            const argument = try borrow(self, body, invocation.argument);
            const cached = self.cache.get(invocation.argument);
            const active = self.state_active;
            const types = self.types;
            const layouts = self.layouts;
            self.state_active = false;
            self.types = self.abi_types;
            self.layouts = self.abi_layouts;

            defer {
                self.state_active = active;
                self.types = types;
                self.layouts = layouts;
            }

            try self.cache.put(self.allocator, invocation.argument, argument);

            defer {
                if (cached) |value| self.cache.put(self.allocator, invocation.argument, value) catch unreachable else _ = self.cache.remove(invocation.argument);
            }

            return @import("root.zig").borrowInvocation(self, body, invocation);
        },
        else => return existing(self, body, id),
    }
}

fn object(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId) Lower.Error!node.ExpressionId {
    const expression = self.program.expression(id);
    const value = expression.value.object;
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: @TypeOf(self.cache).SnapshotBuffer = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const temporary = memory.allocator();
    const saved = try self.cache.snapshot(temporary, value.evaluation);

    defer self.cache.restore(self.allocator, value.evaluation, saved);

    const counts = try temporary.alloc(u64, value.evaluation.len);
    const evaluated = try temporary.alloc(node.ExpressionId, value.evaluation.len);

    for (value.evaluation, 0..) |item, index| {
        evaluated[index] = try aggregate.bind(self, body, try borrow(self, body, item));
        counts[index] = self.cache_reads[@backingInt(item)];

        const cached = if (self.state_active)
            try @import("../state_value/conversion.zig").convert(self, body, self.program.expression(item).type_id, evaluated[index], .value)
        else
            evaluated[index];

        try self.cache.put(self.allocator, item, cached);
    }

    const type_fields = self.program.typeOf(expression.type_id).object;
    const fields = try self.allocator.alloc(node.Field, value.fields.len);

    for (0..value.fields.len) |index| {
        const field = value.fields.at(index);

        fields[index] = .{
            .name = type_fields.at(field.index).name,
            .value = try existing(self, body, field.value),
        };
    }

    try operands.retire(self, temporary, body, .{
        .evaluation = value.evaluation,
        .prior = counts,
        .references = evaluated,
    });

    const result = try aggregate.bind(self, body, try self.builder.expression(.{ .object = .{ .type_expr = try @import("../types.zig").get(self, self.abi_layouts, expression.type_id), .fields = fields } }));

    return self.builder.expression(.{ .address_of = result });
}

fn existing(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId) Lower.Error!node.ExpressionId {
    const value = try self.expr(id);
    const type_id = self.program.expression(id).type_id;

    if (!self.state_active or !self.state_plan.represented(self.program, type_id)) return value;

    const bound = try aggregate.bind(self, body, value);

    return @import("../state_value/conversion.zig").convert(self, body, type_id, bound, .borrow);
}
