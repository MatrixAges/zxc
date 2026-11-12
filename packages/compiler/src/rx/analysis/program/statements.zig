const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("builder.zig");
const Flow = @import("flow.zig");
const Module = @import("../module.zig");
const Shape = @import("control/shape.zig");
const Plan = @import("control/plan.zig");
const Writer = @import("control/writer.zig");
const inlineValue = @import("expression.zig").inlineValue;
const Self = @This();

builder: *Builder,
shape: *const Shape,
plan: Plan,
writer: *Writer,
calls: []const Module.Call,
pub fn lower(self: *const Self, sequence: []const Flow.Step, owner: u32, cursor: *Writer.Cursor) Builder.Error!void {
    const builder = self.builder;

    for (sequence, 0..) |*step, index| {
        switch (step.*) {
            .call => |invocation| try self.call(cursor, self.calls[invocation]),
            .parallel => |indices| try self.parallel(cursor, indices),
            .result => |program| self.writer.result(cursor, try inlineValue(builder, program)),
            .task => |task| {
                const count = builder.bindings.items.len;
                const child = self.shape.child(owner, index);

                try self.lower(task.body, child, cursor);

                var result: ?ir.SymbolId = null;

                if (task.output) |output| {
                    const value = try inlineValue(builder, output.value);

                    if (output.name) |name| {
                        const symbol = try builder.symbol(name, builder.expressionType(value), builder.expressionSpan(value));

                        self.writer.constant(cursor, symbol, value);

                        result = symbol;
                    } else self.writer.evaluate(cursor, value);
                }

                builder.bindings.shrinkRetainingCapacity(count);
                if (result) |symbol| try builder.bindings.append(builder.allocator, symbol);
            },
            .selection => |selection| {
                const subject = try inlineValue(builder, selection.subject);
                const first = cursor.counts.cases;
                const children = self.shape.child(owner, index);
                const units = self.shape.cases.items[children..][0..selection.cases.len];

                for (selection.cases, units, @as(usize, first)..) |*source, unit, position| {
                    const value = if (source.value) |program| try inlineValue(builder, program) else null;
                    const body = try self.block(source.body, unit);

                    self.writer.selectionCase(position, value, body);
                }

                self.writer.selection(cursor, subject, selection.cases.len, selection.exhaustive);
            },
        }
    }
}

fn block(self: *const Self, sequence: []const Flow.Step, unit: u32) Builder.Error!ir.BlockId {
    const count = self.builder.bindings.items.len;
    const row = self.plan.rows[unit];
    var cursor = Writer.Cursor.init(row.first);

    defer self.builder.bindings.shrinkRetainingCapacity(count);

    try self.lower(sequence, unit, &cursor);

    return self.writer.block(row, cursor, self.plan.end(unit));
}

fn parallel(self: *const Self, cursor: *Writer.Cursor, indices: []const usize) Builder.Error!void {
    const builder = self.builder;
    const first = cursor.counts.invocations;

    for (indices, @as(usize, first)..) |index, position| {
        const invocation = self.calls[index];
        const value = try self.invoke(cursor, invocation);
        const symbol = if (invocation.out) |name| try builder.symbol(name, builder.expressionType(value), builder.expressionSpan(value)) else null;

        self.writer.parallelBranch(position, symbol, value);
    }

    self.writer.parallel(cursor, indices.len);

    for (self.writer.columns.parallel_symbols.items[first..][0..indices.len]) |symbol| {
        if (symbol) |id| try builder.bindings.append(builder.allocator, @fromBackingInt(id));
    }
}

fn call(self: *const Self, cursor: *Writer.Cursor, invocation: Module.Call) Builder.Error!void {
    const builder = self.builder;
    const value = try self.invoke(cursor, invocation);

    const name = invocation.out orelse {
        self.writer.evaluate(cursor, value);

        return;
    };

    const symbol = try builder.symbol(name, invocation.callee.output_type, builder.expressionSpan(value));

    self.writer.constant(cursor, symbol, value);

    try builder.bindings.append(builder.allocator, symbol);
}

fn invoke(self: *const Self, cursor: *Writer.Cursor, invocation: Module.Call) Builder.Error!ir.ExprId {
    const builder = self.builder;
    const count = builder.bindings.items.len;
    const location = invocation.argument.symbols.at(0).span;

    for (invocation.getters) |getter| {
        const slot = try builder.store(getter.slot);
        const snapshot = try builder.expression(.{ .type_id = getter.slot.type_id, .span = location, .value = .{ .store_get = slot } });
        const symbol = try builder.symbol(getter.name, getter.slot.type_id, location);

        self.writer.constant(cursor, symbol, snapshot);

        try builder.bindings.append(builder.allocator, symbol);
    }

    const argument = if (invocation.input_omitted) try builder.expression(.{ .type_id = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))), .span = location, .value = .unit }) else try inlineValue(builder, invocation.argument);

    builder.bindings.shrinkRetainingCapacity(count);

    const stores = try builder.allocator.alloc(u32, invocation.callee.stores.count());

    for (stores, 0..) |*mapped, index| mapped.* = try builder.store(invocation.callee.stores.at(index));

    const function = try builder.importFunction(invocation.callee, invocation.store_initializers, invocation.function_id);

    return builder.expression(.{ .type_id = invocation.callee.output_type, .span = builder.expressionSpan(argument), .value = .{ .call = .{ .function = function, .argument = argument, .stores = stores } } });
}
