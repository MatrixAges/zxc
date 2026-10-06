const std = @import("std");
const ir = @import("zx").ir;
const capabilities = @import("capabilities.zig");

pub fn uses(expressions: []const ir.Expression, contracts: []const ir.Contract, required: []const bool) bool {
    for (expressions) |expression| switch (expression.value) {
        .task, .await_task, .cancel_task, .parallel => return true,
        else => {},
    };

    return capabilities.uses(expressions, contracts, required);
}

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    return capabilities.functions(allocator, program, .io);
}
