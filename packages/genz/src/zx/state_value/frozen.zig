const std = @import("std");
const ir = @import("zx").ir;

/// Records neither constructed nor forwarding aggregate state keep their ABI pointer. Child values retain their layouts and
/// convert at projection boundaries; shared identity, native and task boundaries are boxed before this pass.
pub fn mark(allocator: std.mem.Allocator, program: ir.Program, boxed: []bool) std.mem.Allocator.Error!void {
    const count = program.types.count();
    const built = try allocator.alloc(bool, count);

    defer allocator.free(built);
    @memset(built, false);
    constructions(built, program.expressions, program.contracts);

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        constructions(built, function.expressions, function.contracts);
    }

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        if (function.external == null and !built[@backingInt(function.input_type)] and program.typeOf(function.input_type) == .object and @import("../value_call/analysis.zig").sharesAggregate(program, function.input_type, function.output_type)) {
            built[@backingInt(function.input_type)] = true;
        }
    }

    for (0..count) |index| {
        if (program.types.at(index) == .object and !built[index]) boxed[index] = true;
    }
}

fn constructions(built: []bool, expressions: ir.ExpressionTable, contracts: ir.ContractTable) void {
    for (expressions.kinds, expressions.types) |kind, type_id| {
        if (kind == .Object or kind == .Tuple or kind == .Parallel) built[type_id] = true;
    }

    for (contracts.expressions) |table| constructions(built, table.*, .{});
}
