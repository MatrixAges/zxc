const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("builder.zig");
const Flow = @import("flow.zig");
const Module = @import("../module.zig");
const inlineValue = @import("expression.zig").inlineValue;

pub fn lower(builder: *Builder, sequence: []const Flow.Step, calls: []const Module.Call) Builder.Error!void {
    for (sequence) |step| {
        if (ir.terminates(builder.body.items)) return error.UnreachableFlow;

        switch (step) {
            .call => |index| try call(builder, calls[index], index),
            .result => |program| try builder.body.append(builder.allocator, .{ .result = try inlineValue(builder, program) }),
            .task => |body| {
                const count = builder.bindings.items.len;

                try lower(builder, body, calls);

                builder.bindings.shrinkRetainingCapacity(count);
            },
            .selection => |selection| {
                const subject = try inlineValue(builder, selection.subject);
                const type_id = builder.expressions.items[@intFromEnum(subject)].type_id;
                const target = builder.types[@intFromEnum(type_id)];
                const cases = try builder.allocator.alloc(ir.SwitchCase, selection.cases.len);
                var has_default = false;

                for (selection.cases, cases) |source, *item| {
                    const value = if (source.value) |program| try inlineValue(builder, program) else null;

                    if (value == null) has_default = true;

                    item.* = .{ .value = value, .body = try block(builder, source.body, calls) };
                }

                const exhaustive = has_default or (target == .enumeration and cases.len == target.enumeration.members.len) or (type_id == @as(ir.TypeId, @enumFromInt(@intFromEnum(ir.Scalar.bool))) and cases.len == 2);

                try builder.body.append(builder.allocator, .{ .switch_stmt = .{ .subject = subject, .cases = cases, .exhaustive = exhaustive } });
            },
        }
    }
}

fn block(builder: *Builder, sequence: []const Flow.Step, calls: []const Module.Call) Builder.Error![]const ir.Statement {
    const parent = builder.body;
    const count = builder.bindings.items.len;
    builder.body = .empty;

    defer {
        builder.body = parent;

        builder.bindings.shrinkRetainingCapacity(count);
    }

    try lower(builder, sequence, calls);

    return builder.body.items;
}

fn call(builder: *Builder, invocation: Module.Call, index: usize) Builder.Error!void {
    const count = builder.bindings.items.len;
    const location = invocation.argument.symbols[0].span;

    for (invocation.getters) |getter| {
        const slot = try builder.store(getter.slot);
        const snapshot = try builder.expression(.{ .type_id = getter.slot.type_id, .span = location, .value = .{ .store_get = slot } });
        const symbol = try builder.symbol(getter.name, getter.slot.type_id, location);

        try builder.body.append(builder.allocator, .{ .constant = .{ .symbol = symbol, .value = snapshot } });
        try builder.bindings.append(builder.allocator, symbol);
    }

    const argument = try inlineValue(builder, invocation.argument);

    builder.bindings.shrinkRetainingCapacity(count);

    const stores = try builder.allocator.alloc(u32, invocation.callee.stores.len);

    for (invocation.callee.stores, stores) |slot, *mapped| mapped.* = try builder.store(slot);

    const span = builder.expressions.items[@intFromEnum(argument)].span;
    const function = try builder.importFunction(invocation.callee);
    const value = try builder.expression(.{ .type_id = invocation.callee.output_type, .span = span, .value = .{ .call = .{ .function = function, .argument = argument, .stores = stores } } });
    const name = invocation.out orelse try std.fmt.allocPrint(builder.allocator, "discard_{d}", .{index});
    const symbol = try builder.symbol(name, invocation.callee.output_type, span);

    try builder.body.append(builder.allocator, .{ .constant = .{ .symbol = symbol, .value = value } });
    if (invocation.out != null) try builder.bindings.append(builder.allocator, symbol);
}
