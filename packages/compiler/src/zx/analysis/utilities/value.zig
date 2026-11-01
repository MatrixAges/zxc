const zx = @import("zx");
const ir = zx.ir;
const Builder = @import("../collections/builder.zig");
const Types = @import("../types.zig");
const numbers = @import("../numbers.zig");
const Operation = @import("../utilities.zig").Operation;

pub fn binary(builder: Builder, operator: ir.Operator, left: ir.ExprId, right: ir.ExprId) zx.Error!ir.ExprId {
    const type_id = switch (operator) {
        .add, .subtract => builder.analyzer.node(left).type_id,
        else => Types.scalarId(.bool),
    };

    return builder.expression(type_id, .{ .binary = .{ .operator = operator, .left = left, .right = right } });
}

pub fn choice(builder: Builder, condition: ir.ExprId, yes: ir.ExprId, no: ir.ExprId) zx.Error!ir.ExprId {
    return builder.expression(builder.analyzer.node(yes).type_id, .{ .conditional = .{ .condition = condition, .yes = yes, .no = no } });
}

pub fn lower(builder: Builder, operation: Operation, values: []const ir.ExprId) zx.Error!ir.ExprId {
    const first = values[0];
    const type_id = builder.analyzer.node(first).type_id;

    if (operation == .identity) return first;

    if (operation == .isNil or operation == .isNotNil) {
        if (builder.analyzer.types.get(type_id) != .optional) return builder.expression(Types.scalarId(.bool), .{ .boolean = operation == .isNotNil });

        const none = try builder.expression(type_id, .none);

        return binary(builder, if (operation == .isNil) .equal else .not_equal, first, none);
    }

    if (operation == .clamp or operation == .inRange) {
        if (!numbers.isInteger(type_id) and !numbers.isFloat(type_id)) return builder.analyzer.reporter.fail(.type_mismatch, builder.span, "numeric utility requires numeric values of the same type");

        const lower_bound = values[1];
        const upper_bound = values[2];

        if (operation == .inRange) {
            const ordered = try binary(builder, .less_equal, lower_bound, upper_bound);
            const start = try choice(builder, ordered, lower_bound, upper_bound);
            const end = try choice(builder, ordered, upper_bound, lower_bound);

            return binary(builder, .logical_and, try binary(builder, .greater_equal, first, start), try binary(builder, .less, first, end));
        }

        const bounded = try choice(builder, try binary(builder, .less, first, lower_bound), lower_bound, first);

        return choice(builder, try binary(builder, .greater, bounded, upper_bound), upper_bound, bounded);
    }

    if (builder.analyzer.types.get(type_id) != .list) return builder.analyzer.reporter.fail(.type_mismatch, builder.span, "array utility requires a list");

    return @import("list.zig").lower(builder, operation, values);
}
