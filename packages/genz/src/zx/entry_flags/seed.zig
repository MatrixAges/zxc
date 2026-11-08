const std = @import("std");
const ir = @import("zx").ir;

pub const Flags = struct { inlined: bool = false, body_process: bool, io: bool, process: bool, scalar: bool, tasks: bool, value: bool };

const minimum_record_fields = 6;
const maximum_routing_fields = 4;
const maximum_body_expressions = 192;
const maximum_result_fields = 4;
const maximum_scalar_expressions = 32;

pub fn analyze(program: ir.Program, functions: anytype) Flags {
    const io = @import("../io.zig").uses(program.expressions, program.contracts, functions.io);
    const process = @import("../capabilities.zig").uses(program.expressions, program.contracts, functions.process);
    const tasks = @import("../tasks/allocator.zig").required(program, functions.tasks);

    return .{
        .inlined = !io and !process and !tasks and inlined(program, functions.self_function, functions.pure),
        .value = eligibleEntry(program, functions.local),
        .scalar = scalarLocals(program, functions.local),
        .io = io,
        .process = process,
        .body_process = @import("../capabilities.zig").uses(program.expressions, .{}, functions.process),
        .tasks = tasks,
    };
}

/// Matches Source entry/inlined: only small, bounded helpers with earlier pure callees.
fn inlined(program: ir.Program, owner: ?ir.FunctionId, pure: []const bool) bool {
    const function = owner orelse return false;

    if (program.stores.count() != 0 or parallel(program.body.block())) return false;
    if (program.contracts.kinds.len != 0 or program.expressions.count() > maximum_body_expressions) return false;

    const input = program.typeOf(program.input_type);
    const output = program.typeOf(program.output_type);

    if (input != .object) return false;

    var result = output;

    while (result == .optional) result = program.typeOf(result.optional);

    const primitive = result == .scalar or result == .enumeration or result == .error_set or result == .native_reference;

    if (primitive) {
        if (input.object.len > maximum_routing_fields or program.expressions.count() > maximum_scalar_expressions) return false;
    } else if (input.object.len >= minimum_record_fields) {
        if (output != .object or output.object.len > maximum_result_fields) return false;
    } else {
        if (input.object.len > maximum_routing_fields or result != .object or result.object.len > maximum_result_fields) return false;

        for (0..result.object.len) |index| {
            var field = program.typeOf(result.object.at(index).type_id);

            while (field == .optional) field = program.typeOf(field.optional);
            if (field != .scalar and field != .enumeration and field != .error_set) return false;
        }
    }

    var cost = program.expressions.count();

    for (program.expressions.kinds, 0..) |kind, index| switch (kind) {
        .Iteration, .Transform, .Task, .Parallel, .AwaitTask, .CancelTask => return false,
        .Object => {
            const fields = program.expressions.object_count[program.expressions.payloads[index]];

            if (fields > maximum_body_expressions - cost) return false;

            cost += fields;
        },
        else => {},
    };

    return calls(program.expressions, program.contracts, pure[0..@backingInt(function)]);
}

pub fn scalarLocals(program: ir.Program, local: []const bool) bool {
    var output = program.typeOf(program.output_type);

    while (output == .optional) output = program.typeOf(output.optional);

    switch (output) {
        .scalar, .enumeration, .error_set => {},
        else => return false,
    }

    return eligibleEntry(program, local);
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
