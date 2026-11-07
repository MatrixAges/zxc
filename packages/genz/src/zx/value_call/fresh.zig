const std = @import("std");
const ir = @import("zx").ir;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const values = try allocator.alloc(bool, program.functions.count());

    for (values, 0..) |*value, index| {
        const function = program.functions.at(index);
        value.* = check(function.expressions, function.body.block());
    }

    return values;
}

pub fn check(expressions: ir.ExpressionTable, statements: ir.Block) bool {
    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        switch (statement) {
            .result => |result| {
                var id = result orelse return false;

                while (true) switch (expressions.at(@backingInt(id)).value) {
                    .scope => |scope| id = scope.result,
                    .object, .tuple => break,
                    else => return false,
                };
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
