const std = @import("std");
const ir = @import("zx").ir;

pub const Flags = struct { inlined: bool = false, body_process: bool, io: bool, process: bool, scalar: bool, tasks: bool, value: bool };

pub fn analyze(program: ir.Program, functions: anytype) Flags {
    return .{
        .value = eligibleEntry(program, functions.local),
        .scalar = scalarLocals(program, functions.pure),
        .io = @import("../io.zig").uses(program.expressions, program.contracts, functions.io),
        .process = @import("../capabilities.zig").uses(program.expressions, program.contracts, functions.process),
        .body_process = @import("../capabilities.zig").uses(program.expressions, .{}, functions.process),
        .tasks = @import("../tasks/allocator.zig").required(program, functions.tasks),
    };
}

pub fn scalarLocals(program: ir.Program, pure: []const bool) bool {
    var output = program.typeOf(program.output_type);

    while (output == .optional) output = program.typeOf(output.optional);

    switch (output) {
        .scalar, .enumeration, .error_set => {},
        else => return false,
    }

    return eligibleEntry(program, pure);
}

pub fn eligibleEntry(program: ir.Program, callees: []const bool) bool {
    return program.stores.count() == 0 and !parallel(program.body.block()) and calls(program.expressions, program.contracts, callees);
}

pub fn calls(expressions: ir.ExpressionTable, contracts: ir.ContractTable, pure: []const bool) bool {
    return callsWithin(expressions, contracts, pure, null);
}

pub fn callsWithin(expressions: ir.ExpressionTable, contracts: ir.ContractTable, pure: []const bool, self_function: ?usize) bool {
    for (0..expressions.count()) |expression_index| {
        if (expressions.concurrent(expression_index)) return false;
        if (expressions.callee(expression_index)) |function| if (@backingInt(function) != self_function and (@backingInt(function) >= pure.len or !pure[@backingInt(function)])) return false;
    }

    for (contracts.expressions) |expressions_table| if (!callsWithin(expressions_table.*, .{}, pure, self_function)) return false;

    return true;
}

pub fn parallel(body: ir.Block) bool {
    for (0..body.len) |statement_index| {
        const statement = body.at(statement_index);

        switch (statement) {
            .parallel => return true,
            .branch => |value| if (parallel(value.yes) or parallel(value.no)) return true,
            .switch_stmt => |value| for (0..value.cases.len) |case_index| {
                const case = value.cases.at(case_index);

                if (parallel(case.body)) return true;
            },
            else => {},
        }
    }

    return false;
}
