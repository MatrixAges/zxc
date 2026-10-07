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
        } else if (kind == .io) @import("io.zig").uses(function.expressions, function.contracts, required[0..index]) else uses(function.expressions, function.contracts, required[0..index]);
    }

    return required;
}

pub fn uses(expressions: ir.ExpressionTable, contracts: ir.ContractTable, required: []const bool) bool {
    for (0..expressions.count()) |expression_index| {
        const expression = expressions.at(expression_index);

        switch (expression.value) {
            .call => |invocation| if (required[@backingInt(invocation.function)]) return true,
            else => {},
        }
    }

    for (contracts.expressions) |expressions_table| if (uses(expressions_table.*, .{}, required)) return true;

    return false;
}
