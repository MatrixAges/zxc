const std = @import("std");
const ir = @import("zx").ir;
const Builder = @import("builder.zig");
const linking = @import("linking.zig");
const Mapping = @import("mapping.zig");
const aggregate = @import("aggregate.zig");

pub fn inlineValue(builder: *Builder, program: ir.Program) Builder.Error!ir.ExprId {
    var buffer: [std.heap.page_size_min / 4]u8 = undefined;
    var scratch = std.heap.BufferFirstAllocator.init(&buffer, builder.linking_scratch.allocator());
    defer _ = builder.linking_scratch.reset(.retain_capacity);
    const plan = try linking.plan(scratch.allocator(), builder, program);
    const local_first = plan.bindings.len + 1;

    var mapping = Mapping{
        .allocator = builder.allocator,
        .bindings = plan.bindings,
        .locals_base = builder.symbols.count(),
        .symbol_count = program.symbols.count(),
        .expressions = plan.rows,
    };

    for (local_first..program.symbols.count()) |index| {
        const symbol = program.symbols.at(index);

        _ = try builder.symbol(symbol.name, symbol.type_id, symbol.span);
    }

    for (plan.rows, 0..) |row, index| {
        if (row == linking.missing) continue;

        mapping.available = index;

        const value = program.expressions.at(index);

        const id = switch (value.value) {
            .list, .tuple, .template, .list_operation, .transform, .scope, .match_expr, .object => try aggregate.append(builder, &mapping, value),
            else => try builder.expression(try mapping.expression(value)),
        };

        std.debug.assert(@backingInt(id) == row);
    }

    mapping.available = plan.rows.len;

    return mapping.id(plan.returned);
}
