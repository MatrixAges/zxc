const std = @import("std");
const ir = @import("zx").ir;
const capabilities = @import("capabilities.zig");

pub fn uses(expressions: ir.ExpressionTable, contracts: ir.ContractTable, required: []const bool) bool {
    for (0..expressions.count()) |expression_index| {
        const expression = expressions.at(expression_index);

        switch (expression.value) {
            .task, .await_task, .cancel_task, .parallel => return true,
            else => {},
        }
    }

    return capabilities.uses(expressions, contracts, required);
}

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    return capabilities.functions(allocator, program, .io);
}
