const std = @import("std");
const ir = @import("zx").ir;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const required = try allocator.alloc(bool, program.functions.len);

    for (program.functions, 0..) |function, index| {
        required[index] = if (function.external) |external| external.io_argument else uses(function.expressions, function.contracts, required[0..index]);
    }

    return required;
}

pub fn uses(expressions: []const ir.Expression, contracts: []const ir.Contract, required: []const bool) bool {
    for (expressions) |expression| switch (expression.value) {
        .call => |invocation| if (required[@intFromEnum(invocation.function)]) return true,
        else => {},
    };

    for (contracts) |contract| if (uses(contract.expressions, &.{}, required)) return true;

    return false;
}
