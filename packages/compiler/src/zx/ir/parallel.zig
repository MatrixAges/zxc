const std = @import("std");
const ir = @import("zx").ir;

pub fn functions(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]bool {
    const pure = try allocator.alloc(bool, program.functions.len);

    for (program.functions, 0..) |function, index| {
        pure[index] = function.external == null and function.stores.count() == 0 and calls(function.expressions, pure[0..index]);
    }

    return pure;
}

pub fn programPure(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!bool {
    if (program.stores.count() != 0) return false;

    const pure = try functions(allocator, program);

    defer allocator.free(pure);

    return calls(program.expressions, pure);
}

fn calls(expressions: ir.ExpressionTable, pure: []const bool) bool {
    for (0..expressions.count()) |expression_index| {
        const expression = expressions.at(expression_index);

        switch (expression.value) {
            .task, .await_task, .cancel_task, .parallel => return false,
            .store_get => return false,
            .call => |invocation| {
                const index = @backingInt(invocation.function);

                if (invocation.stores.len != 0 or index >= pure.len or !pure[index]) return false;
            },
            else => {},
        }
    }

    return true;
}
