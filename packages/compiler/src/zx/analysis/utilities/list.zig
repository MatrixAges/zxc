const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("../collections/builder.zig");
const Types = @import("../types.zig");
const numbers = @import("../numbers.zig");
const Operation = @import("../utilities.zig").Operation;
const value = @import("value.zig");

pub fn lower(builder: Builder, operation: Operation, values: []const ir.ExprId) zx.Error!ir.ExprId {
    const analyzer = builder.analyzer;
    const source = values[0];
    const list_type = analyzer.node(source).type_id;
    const element_type = analyzer.types.get(list_type).list;

    if (operation == .take or operation == .takeRight or operation == .drop or operation == .dropRight) return @import("range.zig").lower(builder, operation, values);

    const length = try builder.expression(Types.scalarId(.u64), .{ .length = source });
    const zero = try builder.integer(0);
    const present = try value.binary(builder, .greater, length, zero);

    if (operation == .head or operation == .last) {
        const optional = try analyzer.types.wrap(.optional, element_type);
        const index = if (operation == .head) zero else try value.binary(builder, .subtract, length, try builder.integer(1));
        const element = try builder.expression(element_type, .{ .index = .{ .target = source, .index = index } });

        return value.choice(builder, present, try builder.expression(optional, .{ .some = element }), try builder.expression(optional, .none));
    }

    if (!numbers.isInteger(element_type) and !numbers.isFloat(element_type)) return analyzer.reporter.fail(.type_mismatch, builder.span, "numeric array utility requires numeric elements");

    const parameters = [_]ir.SymbolId{
        try builder.symbol("$utils_item", element_type),
        try builder.symbol("$utils_index", element_type),
    };

    const first = try builder.reference(parameters[0]);
    const second = try builder.reference(parameters[1]);

    const initial = if (operation == .sum)
        try builder.expression(element_type, if (numbers.isFloat(element_type)) .{ .float = 0 } else .{ .integer = 0 })
    else
        try builder.expression(element_type, .{ .index = .{ .target = source, .index = zero } });

    const body = if (operation == .sum)
        try value.binary(builder, .add, first, second)
    else
        try value.choice(builder, try value.binary(builder, if (operation == .min) .less else .greater, first, second), first, second);

    const result = try @import("../collections/lower.zig").lower(analyzer, .{
        .span = builder.span,
        .kind = .reduce,
        .target = source,
        .initial = initial,
        .ignored = null,
        .callback = .{ .parameters = try analyzer.allocator.dupe(ir.SymbolId, &parameters), .captures = &.{}, .body = body },
        .result_type = element_type,
    });

    if (operation != .min and operation != .max) return result;

    const optional = try analyzer.types.wrap(.optional, element_type);

    return value.choice(builder, present, try builder.expression(optional, .{ .some = result }), try builder.expression(optional, .none));
}
