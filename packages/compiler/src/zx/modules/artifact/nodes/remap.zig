const std = @import("std");
const generated = @import("generated_artifact_remap");
const Error = @import("../model.zig").Error;

pub fn columns(arena: *std.heap.ArenaAllocator, types: []const u32, type_mapping: []const u64, functions: []const u32, function_mapping: []const u64) Error!std.meta.Child(generated.Output) {
    const Input = std.meta.Child(generated.Input);
    const input: Input = .{ .types = types, .type_mapping = type_mapping, .functions = functions, .function_mapping = function_mapping };

    const result = generated.execute(arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => return error.InvalidModule,
    };

    return result orelse error.InvalidModule;
}
