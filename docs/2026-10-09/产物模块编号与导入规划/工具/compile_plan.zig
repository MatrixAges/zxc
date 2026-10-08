const std = @import("std");
const plan = @import("plan");
const signature = @typeInfo(@TypeOf(plan.execute)).@"fn";
const Input = signature.param_types[1].?;
const Output = @typeInfo(signature.return_type.?).error_union.payload;

export fn compilePlan(arena: *std.heap.ArenaAllocator, input: Input, output: *Output) bool {
    output.* = plan.execute(arena, input) catch return false;

    return true;
}
