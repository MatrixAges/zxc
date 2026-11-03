const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Order = @import("../order.zig");
const Slots = @import("../slots.zig");
const generated = @import("generated_uniqueness_flow_prepare");
const Input = std.meta.Child(generated.Input);
pub const Prepared = std.meta.Child(generated.Output);
const Self = @This();

function: ir.Function,
order: Order,
prepared: Prepared,
pub fn create(allocator: std.mem.Allocator, function: ir.Function, slots: Slots) std.mem.Allocator.Error!Self {
    const input = Input{
        .expressions = zx.columns.pointer(@FieldType(Input, "expressions"), &function.expressions),
        .counts = slots.counts,
        .symbols = function.symbols.count(),
    };

    const prepared = generated.executeIn(allocator, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };

    return .{
        .function = function,
        .order = try Order.create(allocator, allocator, function.symbols, function.expressions, function.body.block()),
        .prepared = prepared.*,
    };
}
