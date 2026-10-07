const ir = @import("zx").ir;

pub fn matches(expressions: []const ir.Expression, id: ir.ExprId) bool {
    const value = expressions[@backingInt(id)].value;

    if (value != .list_operation or value.list_operation.kind != .splice) return false;

    const start = expressions[@backingInt(value.list_operation.arguments[0])].value;

    return start == .integer and start.integer == 0;
}
