const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const context = @import("context.zig");
const Call = @FieldType(@FieldType(ir.ExpressionRow, "value"), "call");

pub fn invocation(lowering: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    const call = lowering.program.expression(id).value.call;
    const lanes = lowering.buffer_functions[@backingInt(call.function)];
    const buffers = try context.argument(lowering, lanes, lowering.buffer_calls.get(id).?);
    const argument = try lowering.expr(call.argument);

    return invoke(lowering, call.function, argument, buffers);
}

pub fn transfer(lowering: *Lower, call: Call, selected: []const bool) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    var argument = try lowering.expr(call.argument);
    const buffers = try @import("transfer/root.zig").prepare(lowering, &body, call, &argument, selected);
    const result = try invoke(lowering, call.function, argument, buffers);

    return aggregate.finish(lowering, &body, result);
}

fn invoke(lowering: *Lower, function: ir.FunctionId, argument: *const node.Expression, buffers: *const node.Expression) Lower.Error!*const node.Expression {
    const callee = try lowering.requestFunction(function, .buffered_pointer);

    return lowering.call(callee, &.{ try lowering.builder.identifier("allocator"), argument, buffers }, true);
}
