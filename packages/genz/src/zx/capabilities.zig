const std = @import("std");
const ir = @import("zx").ir;
pub const Kind = enum { io, process };

pub fn functions(allocator: std.mem.Allocator, program: ir.Program, kind: Kind) std.mem.Allocator.Error![]bool {
    const required = try allocator.alloc(bool, program.functions.count());

    for (0..program.functions.count()) |index| {
        const function = program.functions.at(index);

        required[index] = if (function.external) |external| switch (kind) {
            .io => external.io_argument,
            .process => external.process_argument,
        } else if (kind == .io) @import("io.zig").usesWithin(function.expressions, function.contracts, required[0..index], index) else usesWithin(function.expressions, function.contracts, required[0..index], index);
    }

    return required;
}

pub fn uses(expressions: ir.ExpressionTable, contracts: ir.ContractTable, required: []const bool) bool {
    return usesWithin(expressions, contracts, required, null);
}

pub fn usesWithin(expressions: ir.ExpressionTable, contracts: ir.ContractTable, required: []const bool, self_function: ?usize) bool {
    for (0..expressions.count()) |expression_index| {
        if (expressions.callee(expression_index)) |function| if (@backingInt(function) != self_function and (@backingInt(function) >= required.len or required[@backingInt(function)])) return true;
    }

    for (contracts.expressions) |expressions_table| if (usesWithin(expressions_table.*, .{}, required, self_function)) return true;

    return false;
}
