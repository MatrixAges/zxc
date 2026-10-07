const std = @import("std");
const ir = @import("zx").ir;
const Builder = @import("builder.zig");
const Mapping = @import("mapping.zig");

pub fn inlineValue(builder: *Builder, program: ir.Program) Builder.Error!ir.ExprId {
    if (program.body.len == 0) return error.InvalidModule;

    const count = program.body.len - 1;

    if (program.functions.len != 0 or program.stores.len != 0) return error.InvalidModule;
    if (program.symbols.count() < count + 1) return error.InvalidModule;

    var mapping = Mapping{
        .allocator = builder.allocator,
        .symbols = try builder.allocator.alloc(?ir.SymbolId, program.symbols.count()),
        .expressions = try builder.allocator.alloc(?ir.ExprId, program.expressions.count()),
    };

    const projections = try builder.allocator.alloc(bool, program.expressions.count());

    @memset(mapping.symbols, null);
    @memset(mapping.expressions, null);
    @memset(projections, false);

    for (program.body[0..count], 0..) |statement, index| {
        if (statement != .constant) return error.InvalidModule;

        const source = statement.constant;

        if (@backingInt(source.symbol) >= mapping.symbols.len or @backingInt(source.value) >= program.expressions.count()) return error.InvalidModule;

        const value = program.expression(source.value);

        if (value.value != .tuple_field or value.value.tuple_field.index != index) return error.InvalidModule;
        if (@backingInt(value.value.tuple_field.target) >= program.expressions.count()) return error.InvalidModule;

        const environment = program.expression(value.value.tuple_field.target);

        if (environment.value != .reference or @backingInt(environment.value.reference) != 0) return error.InvalidModule;

        const symbol = program.symbols.at(@backingInt(source.symbol));

        for (builder.bindings.items) |binding| {
            const target = builder.symbols.at(@backingInt(binding));

            if (!std.mem.eql(u8, symbol.name, target.name)) continue;
            if (symbol.type_id != target.type_id) return error.InvalidModule;

            mapping.symbols[@backingInt(source.symbol)] = binding;
        }

        projections[@backingInt(source.value)] = true;
    }

    for (0..program.symbols.count()) |index| {
        const symbol = program.symbols.at(index);

        if (index == 0 or mapping.symbols[index] != null) continue;

        var environment_binding = false;

        for (program.body[0..count]) |statement| {
            if (@backingInt(statement.constant.symbol) == index) environment_binding = true;
        }

        if (environment_binding) continue;

        mapping.symbols[index] = try builder.symbol(symbol.name, symbol.type_id, symbol.span);
    }

    for (0..program.expressions.count()) |index| {
        const expression = program.expressions.at(index);

        if (projections[index]) continue;
        if (expression.value == .reference and @backingInt(expression.value.reference) == 0) continue;

        mapping.expressions[index] = try builder.expression(try mapping.expression(expression));
    }

    const returned = program.body[count];

    if (returned != .result or returned.result == null) return error.InvalidModule;

    return mapping.id(returned.result.?);
}
