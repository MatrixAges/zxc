const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub const Plan = struct { order: []const u32, ends: []const u64 };

pub fn build(allocator: std.mem.Allocator, functions: ir.FunctionTable) std.mem.Allocator.Error!?Plan {
    if (!@import("genz_options").generated_analysis) return @import("seed.zig").build(Plan, allocator, functions);

    const generated = @import("generated_uniqueness_layers");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .native_modules = functions.native_modules,
        .expressions = zx.columns.slice(@FieldType(Input, "expressions"), functions.expressions),
    };

    const output = (zx.columns.invoke(generated.executeValue, allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    }) orelse return null;

    return .{ .order = output.order, .ends = output.ends };
}
