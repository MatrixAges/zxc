const ir = @import("zx").ir;

pub const Capacity = struct { operation: u32, source: u32 };

/// Source capacity/bound and capacity/append: one append per zero-based input traversal.
pub fn plan(expressions: ir.ExpressionTable, iteration: ir.Iteration, mutable: []const bool) ?Capacity {
    const condition = expressions.get(iteration.condition).value;

    if (condition != .binary or condition.binary.operator != .less) return null;

    const index = field(expressions, condition.binary.left, iteration.condition_parameter) orelse return null;
    const length = expressions.get(condition.binary.right).value;

    if (length != .length) return null;

    const source = field(expressions, length.length, iteration.condition_parameter) orelse return null;

    if (mutable[source]) return null;

    const initial = unwrap(expressions, iteration.initial);
    const start = expressions.get(member(expressions, initial, index) orelse return null).value;

    if (start != .integer or start.integer != 0) return null;

    const body = unwrap(expressions, iteration.body);
    const next = expressions.get(member(expressions, body, index) orelse return null).value;

    if (next != .binary or next.binary.operator != .add) return null;

    const step = expressions.get(next.binary.right).value;

    if (step != .integer or step.integer != 1) return null;
    if (field(expressions, next.binary.left, iteration.parameter) != index) return null;

    const object = expressions.get(body).value.object;

    for (0..object.fields.len) |position| {
        const slot = object.fields.at(position);
        const value = expressions.get(slot.value).value;

        if (value != .tuple_field or value.tuple_field.index != 0) continue;

        const operation = expressions.get(value.tuple_field.target).value;

        if (operation != .list_operation or operation.list_operation.kind != .push) continue;
        if (field(expressions, operation.list_operation.target, iteration.parameter) != slot.index) continue;

        const seed = expressions.get(member(expressions, initial, slot.index) orelse continue).value;

        if (seed == .list and seed.list.len == 0) return .{ .operation = @backingInt(value.tuple_field.target), .source = source };
    }

    return null;
}

fn field(expressions: ir.ExpressionTable, value: ir.ExprId, parameter: ir.SymbolId) ?u32 {
    const projection = expressions.get(value).value;

    if (projection != .field) return null;

    const target = expressions.get(projection.field.target).value;

    return if (target == .reference and target.reference == parameter) projection.field.index else null;
}

fn member(expressions: ir.ExpressionTable, value: ir.ExprId, index: u32) ?ir.ExprId {
    const object = expressions.get(value).value;

    if (object != .object) return null;

    for (0..object.object.fields.len) |position| {
        const item = object.object.fields.at(position);

        if (item.index == index) return item.value;
    }

    return null;
}

fn unwrap(expressions: ir.ExpressionTable, value: ir.ExprId) ir.ExprId {
    var current = value;

    while (expressions.get(current).value == .scope) current = expressions.get(current).value.scope.result;

    return current;
}
