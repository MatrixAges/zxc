const ir = @import("zx").ir;
const Builder = @import("builder.zig");
const Mapping = @import("mapping.zig");

pub fn inlineValue(builder: *Builder, program: ir.Program) Builder.Error!ir.ExprId {
    const count = builder.bindings.items.len;

    if (program.functions.len != 0 or program.stores.len != 0 or program.body.len != count + 1) return error.InvalidModule;
    if (program.symbols.len < count + 1) return error.InvalidModule;

    var mapping = Mapping{
        .allocator = builder.allocator,
        .symbols = try builder.allocator.alloc(?ir.SymbolId, program.symbols.len),
        .expressions = try builder.allocator.alloc(?ir.ExprId, program.expressions.len),
    };

    const projections = try builder.allocator.alloc(bool, program.expressions.len);

    @memset(mapping.symbols, null);
    @memset(mapping.expressions, null);
    @memset(projections, false);

    for (program.body[0..count], builder.bindings.items, 0..) |statement, binding, index| {
        if (statement != .constant) return error.InvalidModule;

        const source = statement.constant;

        if (@intFromEnum(source.symbol) >= mapping.symbols.len or @intFromEnum(source.value) >= program.expressions.len) return error.InvalidModule;

        const value = program.expression(source.value);

        if (value.value != .tuple_field or value.value.tuple_field.index != index) return error.InvalidModule;
        if (@intFromEnum(value.value.tuple_field.target) >= program.expressions.len) return error.InvalidModule;

        const environment = program.expression(value.value.tuple_field.target);

        if (environment.value != .reference or @intFromEnum(environment.value.reference) != 0) return error.InvalidModule;
        if (program.symbols[@intFromEnum(source.symbol)].type_id != builder.symbols.items[@intFromEnum(binding)].type_id) return error.InvalidModule;

        mapping.symbols[@intFromEnum(source.symbol)] = binding;
        projections[@intFromEnum(source.value)] = true;
    }

    for (program.symbols, 0..) |symbol, index| {
        if (index == 0 or mapping.symbols[index] != null) continue;

        mapping.symbols[index] = try builder.symbol(symbol.name, symbol.type_id, symbol.span);
    }

    for (program.expressions, 0..) |expression, index| {
        if (projections[index]) continue;
        if (expression.value == .reference and @intFromEnum(expression.value.reference) == 0) continue;

        mapping.expressions[index] = try builder.expression(try mapping.expression(expression));
    }

    const returned = program.body[count];

    if (returned != .result or returned.result == null) return error.InvalidModule;

    return mapping.id(returned.result.?);
}
