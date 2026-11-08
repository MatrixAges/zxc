const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
pub const Operation = @FieldType(@FieldType(ir.ExpressionRow, "value"), "call");

pub fn lower(self: *Lower, invocation: Operation) Lower.Error!node.ExpressionId {
    var body: std.ArrayList(node.Statement) = .empty;
    const callee_function = self.program.functions.at(@backingInt(invocation.function));
    const state_callee = self.state_plan.represented(self.program, callee_function.output_type) or self.state_plan.inlineRows(self.program, callee_function.input_type);

    if (self.state_active and self.value_functions[@backingInt(invocation.function)] and state_callee) {
        if (self.state_plan.represented(self.program, callee_function.output_type)) return @import("../value_call/root.zig").invocation(self, invocation);

        return @import("../value_call/root.zig").pointerInvocation(self, invocation);
    }

    if (!self.state_active and self.allows_allocation and self.value_functions[@backingInt(invocation.function)] and self.state_plan.represented(self.program, callee_function.output_type)) return @import("../value_call/root.zig").pointerInvocation(self, invocation);
    if (self.allows_allocation and self.value_functions[@backingInt(invocation.function)] and self.constructed_outputs[@backingInt(invocation.function)]) return @import("../value_call/root.zig").pointerInvocation(self, invocation);

    const scalar = @import("../types/scalar.zig").check(self.program.types, callee_function.output_type);
    const needs_io = self.io_functions[@backingInt(invocation.function)];
    const needs_process = self.process_functions[@backingInt(invocation.function)];
    const arguments = try self.allocator.alloc(node.ExpressionId, 2 + @as(usize, @intFromBool(invocation.stores.len > 0)) + @as(usize, @intFromBool(needs_io)) + @as(usize, @intFromBool(needs_process)));

    arguments[0] = try self.builder.identifier("allocator");

    arguments[1] = if (callee_function.external != null and callee_function.external.?.expand_tuple and self.program.expression(invocation.argument).value == .tuple and !self.cache.contains(invocation.argument)) temporary: {
        const argument_value = self.program.expression(invocation.argument);
        const layout = try @import("../aggregate.zig").tupleValue(self, argument_value, argument_value.value.tuple);
        const argument = try @import("../aggregate.zig").bind(self, &body, try self.cast(try self.layoutExpr(argument_value.type_id), layout));

        break :temporary try self.builder.expression(.{ .address_of = argument });
    } else if (scalar and (self.pure_functions[@backingInt(invocation.function)] or self.local_functions[@backingInt(invocation.function)]) and !self.cache.contains(invocation.argument)) temporary: {
        break :temporary try @import("../value_call/argument.zig").borrow(self, &body, invocation.argument);
    } else if (self.state_active) converted: {
        const argument = try @import("../aggregate.zig").bind(self, &body, try self.expr(invocation.argument));
        const output = self.program.typeOf(callee_function.output_type);

        const independent = (output == .object or output == .tuple) and
            callee_function.input_type != callee_function.output_type and

            self.value_functions[@backingInt(invocation.function)] and
            self.fresh_outputs[@backingInt(invocation.function)];

        const borrow = !self.state_plan.represented(self.program, callee_function.output_type) and
            (self.pure_functions[@backingInt(invocation.function)] or independent);

        break :converted try @import("../state_value/conversion.zig").convert(self, &body, callee_function.input_type, argument, if (borrow) .borrow else .pointer);
    } else try self.expr(invocation.argument);

    if (invocation.stores.len > 0) arguments[2] = try @import("../store.zig").adapter(self, invocation);

    if (needs_io) {
        self.uses_io = true;

        arguments[2 + @as(usize, @intFromBool(invocation.stores.len > 0))] = try self.builder.identifier("io");
    }

    if (needs_process) {
        self.uses_process = true;
        arguments[arguments.len - 1] = try self.builder.identifier("process");
    }

    var result = try self.call(try self.functionReference(invocation.function), arguments, true);

    if (self.state_active and self.state_plan.represented(self.program, callee_function.output_type)) {
        result = try @import("../aggregate.zig").bind(self, &body, result);
        result = try @import("../state_value/conversion.zig").convert(self, &body, callee_function.output_type, result, .value);
    }

    return if (body.items.len == 0) result else try @import("../aggregate.zig").finish(self, &body, result);
}
