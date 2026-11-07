const ir = @import("zx").ir;
const rows = @import("seed_rows.zig");
const read_only = @import("read_only.zig");

/// Same fresh-object sharing boundary as Source state/shared; aliases retain identity.
pub fn mark(program: ir.Program, visible: []const bool, blocked: []bool, expressions: ir.ExpressionTable) void {
    for (0..expressions.count()) |index| {
        const expression = expressions.at(index);

        switch (expression.value) {
            .list_operation => |operation| {
                if (operation.kind == .pop) continue;

                const child = program.typeOf(expressions.get(operation.target).type_id).list;

                if (record(program, child) and (operation.kind != .push or !fresh(expressions, operation.arguments[0]))) rows.mark(program, blocked, child);
            },
            .list_update => |update| {
                const child = program.typeOf(expressions.get(update.target).type_id).list;

                if (record(program, child) and !fresh(expressions, update.value)) rows.mark(program, blocked, child);
            },
            .transform => |transform| {
                const child = if (transform.kind == .map) expressions.get(transform.body).type_id else program.typeOf(expressions.get(transform.target).type_id).list;

                if (!record(program, child)) continue;

                const reused = switch (transform.kind) {
                    .filter => true,
                    .sort => visible[@backingInt(child)],
                    .map => !fresh(expressions, transform.body),
                    else => false,
                };

                if (reused) rows.mark(program, blocked, child);
            },
            .list => |items| {
                const child = program.typeOf(expression.type_id).list;

                if (!record(program, child)) continue;

                for (items) |item| if (!fresh(expressions, item)) {
                    rows.mark(program, blocked, child);

                    break;
                };
            },
            else => {},
        }
    }
}

fn record(program: ir.Program, id: ir.TypeId) bool {
    return program.typeOf(id) == .object and read_only.record(program, id);
}

fn fresh(expressions: ir.ExpressionTable, id: ir.ExprId) bool {
    var current = id;

    while (expressions.get(current).value == .scope) current = expressions.get(current).value.scope.result;

    return expressions.get(current).value == .object;
}
