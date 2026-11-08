const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");
const dispatching = @import("generated_value_dispatch");
const planning = @import("generated_value_call_plan");
pub const Expression = Result(dispatching);
pub const Plan = Result(planning);

pub fn dispatch(self: *const Lower, id: ir.ExprId) Expression {
    const Input = std.meta.Child(dispatching.Input);
    const row = @backingInt(id);
    const value = self.program.expression(id);
    const flags = self.plan.get(id);
    const cached = cache(self, std.meta.Child(@FieldType(Input, "cache")), id);

    const input: Input = .{
        .kind = zx.columns.view(@FieldType(Input, "kind"), self.program.expressions.kinds[row]),
        .type_kind = self.program.types.kinds[@backingInt(value.type_id)],
        .query = zx.columns.view(@FieldType(Input, "query"), self.state_plan.queries[@backingInt(value.type_id)]),
        .normalize = flags.normalize,
        .renew = flags.renew,
        .active = self.state_active,
        .cache = &cached,
        .value_function = if (value.value == .call) self.value_functions[@backingInt(value.value.call.function)] else false,
    };

    return invoke(dispatching, &input);
}

pub fn invocation(self: *const Lower, call: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call"), borrowed: bool, pointer: bool) Plan {
    const Input = std.meta.Child(planning.Input);
    const function = self.program.functions.at(@backingInt(call.function));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);
    const cached = cache(self, std.meta.Child(@FieldType(Input, "cache")), call.argument);

    const input: Input = .{
        .types = &types,
        .cache = &cached,
        .input = @backingInt(function.input_type),
        .output = @backingInt(function.output_type),
        .input_query = zx.columns.view(@FieldType(Input, "input_query"), self.state_plan.queries[@backingInt(function.input_type)]),
        .output_query = zx.columns.view(@FieldType(Input, "output_query"), self.state_plan.queries[@backingInt(function.output_type)]),
        .argument_kind = zx.columns.view(@FieldType(Input, "argument_kind"), self.program.expressions.kinds[@backingInt(call.argument)]),
        .active = self.state_active,
        .allows_allocation = self.allows_allocation,
        .borrowed = borrowed,
        .pointer = pointer,
    };

    return invoke(planning, &input);
}

fn cache(self: *const Lower, comptime Target: type, id: ir.ExprId) Target {
    return .{
        .count = self.cache.state.count,
        .metadata = self.cache.state.metadata.items,
        .keys = self.cache.state.keys.items,
        .key = @backingInt(id),
    };
}

fn Result(comptime entry: type) type {
    return @typeInfo(@typeInfo(@TypeOf(entry.executeValue)).@"fn".return_type.?).error_union.payload;
}

fn invoke(comptime entry: type, input: anytype) Result(entry) {
    var fixed = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, fixed.allocator(), input) catch @panic("invalid value call policy");
}
