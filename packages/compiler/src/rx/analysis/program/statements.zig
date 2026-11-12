const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("builder.zig");
const Flow = @import("flow.zig");
const Module = @import("../module.zig");
const inlineValue = @import("expression.zig").inlineValue;

pub fn lower(builder: *Builder, sequence: []const Flow.Step, calls: []const Module.Call) Builder.Error!bool {
    var terminates = false;

    for (sequence) |step| {
        if (terminates) return error.UnreachableFlow;

        switch (step) {
            .call => |index| try call(builder, calls[index]),
            .parallel => |indices| {
                const invocations = try builder.allocator.alloc(ir.ParallelCall, indices.len);
                var bindings: std.ArrayList(ir.SymbolId) = .empty;

                for (indices, invocations) |index, *invocation| {
                    const value = try invoke(builder, calls[index]);
                    const expression = builder.expressions.view().at(@backingInt(value));
                    const symbol = if (calls[index].out) |name| try builder.symbol(name, expression.type_id, expression.span) else null;
                    invocation.* = .{ .symbol = symbol, .value = value };

                    if (symbol) |id| try bindings.append(builder.allocator, id);
                }

                try builder.body.append(builder.allocator, .{ .parallel = invocations });
                try builder.bindings.appendSlice(builder.allocator, bindings.items);
            },
            .result => |program| {
                try builder.body.append(builder.allocator, .{ .result = try inlineValue(builder, program) });

                terminates = true;
            },
            .task => |task| {
                const count = builder.bindings.items.len;
                terminates = try lower(builder, task.body, calls);

                var result: ?ir.SymbolId = null;

                if (task.output) |output| {
                    const value = try inlineValue(builder, output.value);

                    terminates = false;

                    if (output.name) |name| {
                        const expression = builder.expressions.view().at(@backingInt(value));
                        const symbol = try builder.symbol(name, expression.type_id, expression.span);

                        try builder.body.append(builder.allocator, .{ .constant = .{ .symbol = symbol, .value = value } });

                        result = symbol;
                    } else try builder.body.append(builder.allocator, .{ .evaluate = value });
                }

                builder.bindings.shrinkRetainingCapacity(count);
                if (result) |symbol| try builder.bindings.append(builder.allocator, symbol);
            },
            .selection => |selection| {
                const subject = try inlineValue(builder, selection.subject);
                const cases = try builder.allocator.alloc(ir.SwitchCase, selection.cases.len);
                var all_terminate = true;

                for (selection.cases, cases) |source, *item| {
                    const value = if (source.value) |program| try inlineValue(builder, program) else null;
                    const body = try block(builder, source.body, calls);
                    all_terminate = all_terminate and body.terminates;
                    item.* = .{ .value = value, .body = body.id };
                }

                const exhaustive = selection.exhaustive;

                try builder.body.append(builder.allocator, .{ .switch_stmt = .{ .subject = subject, .cases = cases, .exhaustive = exhaustive } });

                terminates = exhaustive and all_terminate;
            },
        }
    }

    return terminates;
}

fn block(builder: *Builder, sequence: []const Flow.Step, calls: []const Module.Call) Builder.Error!struct { id: ir.BlockId, terminates: bool } {
    const parent = builder.body;
    const count = builder.bindings.items.len;
    builder.body = .empty;

    defer {
        builder.body.deinit(builder.allocator);

        builder.body = parent;

        builder.bindings.shrinkRetainingCapacity(count);
    }

    const terminates = try lower(builder, sequence, calls);

    return .{ .id = try builder.control.appendBlock(builder.allocator, builder.body.items), .terminates = terminates };
}

fn call(builder: *Builder, invocation: Module.Call) Builder.Error!void {
    const value = try invoke(builder, invocation);
    const span = builder.expressions.view().at(@backingInt(value)).span;

    const name = invocation.out orelse {
        try builder.body.append(builder.allocator, .{ .evaluate = value });

        return;
    };

    const symbol = try builder.symbol(name, invocation.callee.output_type, span);

    try builder.body.append(builder.allocator, .{ .constant = .{ .symbol = symbol, .value = value } });
    try builder.bindings.append(builder.allocator, symbol);
}

fn invoke(builder: *Builder, invocation: Module.Call) Builder.Error!ir.ExprId {
    const count = builder.bindings.items.len;
    const location = invocation.argument.symbols.at(0).span;

    for (invocation.getters) |getter| {
        const slot = try builder.store(getter.slot);
        const snapshot = try builder.expression(.{ .type_id = getter.slot.type_id, .span = location, .value = .{ .store_get = slot } });
        const symbol = try builder.symbol(getter.name, getter.slot.type_id, location);

        try builder.body.append(builder.allocator, .{ .constant = .{ .symbol = symbol, .value = snapshot } });
        try builder.bindings.append(builder.allocator, symbol);
    }

    const argument = if (invocation.input_omitted) try builder.expression(.{ .type_id = @fromBackingInt(@intCast(@backingInt(ir.Scalar.void))), .span = location, .value = .unit }) else try inlineValue(builder, invocation.argument);

    builder.bindings.shrinkRetainingCapacity(count);

    const stores = try builder.allocator.alloc(u32, invocation.callee.stores.count());

    for (stores, 0..) |*mapped, index| mapped.* = try builder.store(invocation.callee.stores.at(index));

    const span = builder.expressions.view().at(@backingInt(argument)).span;
    const function = try builder.importFunction(invocation.callee, invocation.store_initializers, invocation.function_id);

    return builder.expression(.{ .type_id = invocation.callee.output_type, .span = span, .value = .{ .call = .{ .function = function, .argument = argument, .stores = stores } } });
}
