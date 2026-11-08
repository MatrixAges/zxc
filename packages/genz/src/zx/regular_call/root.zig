const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const seed = @import("seed.zig");
const aggregate = @import("../aggregate.zig");
const conversion = @import("../state_value/conversion.zig");

pub fn lower(self: *Lower, invocation: seed.Operation) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return seed.lower(self, invocation);

    const selected = @import("policy.zig").analyze(self, invocation);

    switch (selected.route) {
        .Value => return @import("../value_call/root.zig").invocation(self, invocation),
        .Pointer => return @import("../value_call/root.zig").pointerInvocation(self, invocation),
        .Regular => {},
    }

    const plan = selected.regular.?;
    const function = self.program.functions.at(@backingInt(invocation.function));
    const arguments = try self.allocator.alloc(node.ExpressionId, @intCast(plan.argument_count));
    var body: std.ArrayList(node.Statement) = .empty;
    arguments[0] = try self.builder.identifier("allocator");

    arguments[1] = switch (plan.argument) {
        .ExternalTuple => tuple: {
            const value = self.program.expression(invocation.argument);
            const layout = try aggregate.tupleValue(self, value, value.value.tuple);
            const argument = try aggregate.bind(self, &body, try self.cast(try self.layoutExpr(value.type_id), layout));

            break :tuple try self.builder.expression(.{ .address_of = argument });
        },
        .ScalarBorrow => try @import("../value_call/argument.zig").borrow(self, &body, invocation.argument),
        .StateBorrow, .StatePointer => converted: {
            const argument = try aggregate.bind(self, &body, try self.expr(invocation.argument));

            break :converted try conversion.convert(self, &body, function.input_type, argument, if (plan.argument == .StateBorrow) .borrow else .pointer);
        },
        .Value => try self.expr(invocation.argument),
    };

    if (plan.stores) arguments[@intCast(plan.store_slot)] = try @import("../store.zig").adapter(self, invocation);

    if (plan.io) {
        self.uses_io = true;

        arguments[@intCast(plan.io_slot)] = try self.builder.identifier("io");
    }

    if (plan.process) {
        self.uses_process = true;

        arguments[@intCast(plan.process_slot)] = try self.builder.identifier("process");
    }

    var result = try self.call(try self.functionReference(invocation.function), arguments, true);

    if (plan.convert_output) {
        result = try aggregate.bind(self, &body, result);
        result = try conversion.convert(self, &body, function.output_type, result, .value);
    }

    return if (body.items.len == 0) result else try aggregate.finish(self, &body, result);
}
