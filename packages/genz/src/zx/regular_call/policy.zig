const std = @import("std");
const zx = @import("zx");
const Lower = @import("../lower.zig");
const Operation = @import("seed.zig").Operation;
const generated = @import("generated_regular_call_plan");
const Output = std.meta.Child(generated.Output);
pub const Plan = std.meta.Child(@typeInfo(@FieldType(Output, "regular")).optional.child);
pub const Result = struct { route: @FieldType(Output, "route"), regular: ?Plan };

pub fn analyze(self: *const Lower, invocation: Operation) Result {
    const Input = std.meta.Child(generated.Input);
    const Types = std.meta.Child(@FieldType(Input, "types"));
    const Cache = std.meta.Child(@FieldType(Input, "cache"));
    const index = @backingInt(invocation.function);
    const function = self.program.functions.at(index);
    const types: Types = .{ .kinds = self.program.types.kinds, .first = self.program.types.first };

    const cache: Cache = .{
        .count = self.cache.state.count,
        .metadata = self.cache.state.metadata.items,
        .keys = self.cache.state.keys.items,
        .key = @backingInt(invocation.argument),
    };

    const input: Input = .{
        .types = &types,
        .cache = &cache,
        .input = @backingInt(function.input_type),
        .output = @backingInt(function.output_type),
        .input_query = zx.columns.view(@FieldType(Input, "input_query"), self.state_plan.queries[@backingInt(function.input_type)]),
        .output_query = zx.columns.view(@FieldType(Input, "output_query"), self.state_plan.queries[@backingInt(function.output_type)]),
        .argument_kind = zx.columns.view(@FieldType(Input, "argument_kind"), self.program.expressions.kinds[@backingInt(invocation.argument)]),
        .expand_tuple = if (function.external) |external| external.expand_tuple else false,
        .active = self.state_active,
        .allows_allocation = self.allows_allocation,
        .function = index,
        .value_functions = self.value_functions,
        .constructed_outputs = self.constructed_outputs,
        .pure_functions = self.pure_functions,
        .local_functions = self.local_functions,
        .fresh_outputs = self.fresh_outputs,
        .io_functions = self.io_functions,
        .process_functions = self.process_functions,
        .stores = invocation.stores.len,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});
    const output = zx.columns.invoke(generated.executeValue, memory.allocator(), @as(*const Input, &input)) catch @panic("invalid regular invocation policy");

    return .{ .route = output.route, .regular = if (output.regular) |plan| zx.columns.view(Plan, plan) else null };
}
