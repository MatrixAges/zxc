const ir = @import("zx").ir;

pub fn contains(program: ir.Program, type_id: ir.TypeId, root: ir.TypeId) bool {
    return type_id == root or @import("../value_call/analysis.zig").containsDescendant(program, type_id, root);
}

pub fn observes(program: ir.Program, expression: ir.ExpressionRow, root: ir.TypeId) bool {
    return switch (expression.value) {
        .binary => |binary| (binary.operator == .equal or binary.operator == .not_equal) and
            (contains(program, program.expression(binary.left).type_id, root) or contains(program, program.expression(binary.right).type_id, root)),
        .match_expr => |selection| if (selection.subject) |subject| contains(program, program.expression(subject).type_id, root) else false,
        else => false,
    };
}

pub fn fresh(program: ir.Program, id: ir.ExprId) bool {
    return switch (program.expression(id).value) {
        .object, .tuple => true,
        .scope => |scope| fresh(program, scope.result),
        .conditional => |selection| fresh(program, selection.yes) and fresh(program, selection.no),
        .match_expr => |selection| blk: {
            for (0..selection.arms.len) |index| if (!fresh(program, selection.arms.at(index).result)) break :blk false;

            break :blk fresh(program, selection.fallback);
        },
        else => false,
    };
}
