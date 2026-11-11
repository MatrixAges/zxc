const ir = @import("zx").ir;
const Lower = @import("../lower.zig");

/// A loop whose body only forwards its state to a value function of the same type, which then runs on the state layout.
pub fn select(self: *const Lower, iteration: ir.Iteration) Lower.Error!?ir.ExprId {
    const id = forwardedCall(self.program, iteration.body) orelse return null;
    const call = self.program.expression(id).value.call;
    const function = self.program.functions.at(@backingInt(call.function));
    const argument = self.program.expression(call.argument);

    if (!self.value_functions[@backingInt(call.function)]) return null;
    if (self.program.typeOf(function.output_type) != .object) return null;
    if (function.input_type != function.output_type or argument.value != .reference or argument.value.reference != iteration.parameter) return null;
    if (!try @import("../iteration_layout.zig").condition(self.allocator, self.program, iteration, self.pure_functions)) return null;

    return id;
}

fn forwardedCall(program: ir.Program, root: ir.ExprId) ?ir.ExprId {
    var id = root;

    while (true) switch (program.expression(id).value) {
        .call => return id,
        .scope => |scope| {
            if (scope.bindings.len == 0) {
                id = scope.result;

                continue;
            }

            if (scope.bindings.len != 1) return null;

            const symbol = scope.bindings.at(0).symbol orelse return null;
            const result = program.expression(scope.result).value;

            if (result != .reference or result.reference != symbol) return null;

            id = scope.bindings.at(0).value;
        },
        else => return null,
    };
}
