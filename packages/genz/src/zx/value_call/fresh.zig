const ir = @import("zx").ir;

pub fn check(expressions: ir.ExpressionTable, statements: ir.Block) bool {
    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .result => |result| {
                const id = result orelse return false;

                switch (expressions.at(@backingInt(id)).value) {
                    .object, .tuple => {},
                    else => return false,
                }
            },
            .branch => |branch| if (!check(expressions, branch.yes) or !check(expressions, branch.no)) return false,
            .switch_stmt => |selection| for (0..selection.cases.len) |case_index| {
                const case = selection.cases.at(case_index);

                if (!check(expressions, case.body)) return false;
            },
            else => {},
        }
    }

    return true;
}
