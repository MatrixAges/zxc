const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn borrow(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId) Lower.Error!*const node.Expression {
    if (self.cache.contains(id)) return existing(self, body, id);

    const expression = self.program.expression(id);

    switch (expression.value) {
        .object => return object(self, body, id),
        .tuple => |items| {
            const values = try self.allocator.alloc(*const node.Expression, items.len);

            for (items, values) |item, *value| value.* = try aggregate.bind(self, body, try borrow(self, body, item));

            const value = try aggregate.bind(self, body, try self.cast(self.abi_layouts[@backingInt(expression.type_id)], try self.builder.expression(.{ .tuple = values })));

            return self.builder.expression(.{ .address_of = value });
        },
        .call => |invocation| {
            const function = self.program.functions[@backingInt(invocation.function)];

            if (!self.value_functions[@backingInt(invocation.function)] or !fresh(function.expressions, function.body.block())) return existing(self, body, id);

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

fn object(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId) Lower.Error!*const node.Expression {
    const expression = self.program.expression(id);
    const value = expression.value.object;
    const saved = try self.allocator.alloc(?*const node.Expression, value.evaluation.len);

    for (value.evaluation, 0..) |item, index| saved[index] = self.cache.get(item);

    defer {
        for (value.evaluation, 0..) |item, index| {
            if (saved[index]) |previous| self.cache.put(self.allocator, item, previous) catch unreachable else _ = self.cache.remove(item);
        }
    }

    const counts = try self.allocator.alloc(usize, value.evaluation.len);
    const evaluated = try self.allocator.alloc(*const node.Expression, value.evaluation.len);

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

    for (value.evaluation, 0..) |item, index| {
        if (counts[index] == self.cache_reads[@backingInt(item)]) try body.append(self.allocator, .{ .discard = evaluated[index] });
    }

    const result = try aggregate.bind(self, body, try self.builder.expression(.{ .object = .{ .type_expr = self.abi_layouts[@backingInt(expression.type_id)], .fields = fields } }));

    return self.builder.expression(.{ .address_of = result });
}

fn existing(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId) Lower.Error!*const node.Expression {
    const value = try self.expr(id);
    const type_id = self.program.expression(id).type_id;

    if (!self.state_active or !self.state_plan.represented(self.program, type_id)) return value;

    const bound = try aggregate.bind(self, body, value);

    return @import("../state_value/conversion.zig").convert(self, body, type_id, bound, .borrow);
}

fn fresh(expressions: ir.ExpressionTable, statements: ir.Block) bool {
    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .result => |result| {
                const id = result orelse return false;

                switch (expressions.at(@backingInt(id)).value) {
                    .object, .tuple => {},
                    else => return false,
                }
            },
            .branch => |branch| if (!fresh(expressions, branch.yes) or !fresh(expressions, branch.no)) return false,
            .switch_stmt => |selection| for (0..selection.cases.len) |case_index| {
                const case = selection.cases.at(case_index);

                if (!fresh(expressions, case.body)) return false;
            },
            else => {},
        }
    }

    return true;
}
