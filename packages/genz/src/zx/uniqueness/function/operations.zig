const std = @import("std");
const zx = @import("zx");
const Order = @import("../order.zig");
const generated = @import("generated_uniqueness_function_operations");
const Input = std.meta.Child(generated.Input);

pub fn collect(allocator: std.mem.Allocator, order: *const Order, expressions: zx.ir.ExpressionTable) std.mem.Allocator.Error![]const zx.ir.ExprId {
    const input: Input = .{
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &expressions),
        .time = order.nodes.time,
    };

    const result = generated.executeIn(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => std.debug.panic("function operation collection failed: {s}", .{@errorName(err)}),
    };

    return @ptrCast(result);
}
