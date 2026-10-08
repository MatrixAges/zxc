const std = @import("std");
const initial = @import("initial");
const signature = @typeInfo(@TypeOf(initial.execute)).@"fn";
const Input = signature.param_types[1].?;
const Output = @typeInfo(signature.return_type.?).error_union.payload;

export fn compileModules(arena: *std.heap.ArenaAllocator, input: Input, output: *Output) bool {
    output.* = initial.execute(arena, input) catch return false;

    return true;
}
