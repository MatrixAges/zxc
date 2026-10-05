const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn lower(self: *Context, id: ir.ExprId, argument: ir.ExprId) Lower.Error!*const node.Expression {
    const lowering = self.lowering;
    var body: std.ArrayList(node.Statement) = .empty;
    const input = try aggregate.bind(lowering, &body, try lowering.expr(argument));
    const view = try @import("borrow.zig").lower(self, &body, lowering.program.expression(argument).type_id, input);
    const previous = self.argument;
    const cached = lowering.cache.get(argument);

    self.argument = .{ .id = argument, .value = view };
    defer self.argument = previous;

    try lowering.cache.put(lowering.allocator, argument, view);

    defer {
        if (cached) |value| lowering.cache.put(lowering.allocator, argument, value) catch unreachable else _ = lowering.cache.remove(argument);
    }

    const call = lowering.program.expression(id).value.call;

    const invocation = if (lowering.buffer_calls.contains(id))
        try @import("../buffer_call/root.zig").invocation(lowering, id)

    else if (lowering.value_functions[@backingInt(call.function)])
        try @import("../value_call/root.zig").invocation(lowering, call, null)
    else
        try lowering.regular(id);

    const result = try aggregate.bind(lowering, &body, invocation);
    const output = try @import("conversion.zig").convert(self, lowering.program.expression(id).type_id, result, false);

    return aggregate.finish(lowering, &body, output);
}
