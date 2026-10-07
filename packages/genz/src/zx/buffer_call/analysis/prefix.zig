const ir = @import("zx").ir;

pub fn matches(expressions: ir.ExpressionTable, id: ir.ExprId) bool {
    const value = expressions.at(@backingInt(id)).value;

    if (value != .list_operation or value.list_operation.kind != .splice) return false;

    const start = expressions.at(@backingInt(value.list_operation.arguments[0])).value;

    return start == .integer and start.integer == 0;
}
