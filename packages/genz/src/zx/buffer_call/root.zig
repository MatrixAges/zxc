const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Builder = @import("../object_reduce/append/builder.zig");
const context = @import("context.zig");
pub const analysis = @import("analysis/flow.zig");
pub const Lane = analysis.Lane;
pub const fresh = @import("transfer/fresh.zig");
pub const transfer_analysis = @import("transfer/analysis.zig");

pub fn available(lanes: []const Lane) bool {
    for (lanes) |lane| if (lane.rejection == null) return true;

    return false;
}

pub fn declaration(lowering: *Lower, name: []const u8, lanes: []const Lane, mode: enum { value, pointer }) Lower.Error!node.Declaration {
    const previous_calls = lowering.buffer_calls;
    const previous_pointer = lowering.buffer_pointer;
    const previous_type = lowering.buffered_type;
    const previous_appends = lowering.append_overrides;
    const previous_updates = lowering.list_update_buffers;

    lowering.buffer_pointer = mode == .pointer;
    lowering.buffer_calls = .empty;
    lowering.append_overrides = .empty;
    lowering.list_update_buffers = .empty;
    lowering.buffered_type = try context.typeOf(lowering, lanes);

    defer {
        lowering.buffer_calls = previous_calls;
        lowering.append_overrides = previous_appends;
        lowering.list_update_buffers = previous_updates;
        lowering.buffered_type = previous_type;
        lowering.buffer_pointer = previous_pointer;
    }

    for (lanes, 0..) |lane, index| {
        if (lane.rejection != null) continue;

        const builder = try context.builder(lowering, index);

        for (lane.appends) |id| try lowering.append_overrides.put(lowering.allocator, id, builder);

        for (lane.updates) |id| {
            const capacity = @import("../iteration_buffer/capacity.zig"){ .buffer = builder.buffer, .started = builder.started };

            try lowering.list_update_buffers.put(lowering.allocator, id, .{ .buffer = try capacity.items(lowering), .started = builder.started, .capacity = capacity, .enabled = builder.enabled });
        }

        for (lane.calls) |call| try bind(lowering, call.expression, call.lane, builder);
    }

    return if (mode == .pointer or lowering.program.typeOf(lowering.program.output_type) == .list) lowering.function(name, false) else lowering.functionValue(name);
}

pub fn bind(lowering: *Lower, id: ir.ExprId, index: usize, builder: Builder) Lower.Error!void {
    const call = lowering.program.expression(id).value.call;
    const slots = try lowering.allocator.alloc(?Builder, lowering.buffer_functions[@backingInt(call.function)].len);

    if (lowering.buffer_calls.get(id)) |previous| @memcpy(slots, previous) else @memset(slots, null);

    std.debug.assert(slots[index] == null);

    slots[index] = builder;

    try lowering.buffer_calls.put(lowering.allocator, id, slots);
}

pub fn invocation(lowering: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    const call = lowering.program.expression(id).value.call;
    const lanes = lowering.buffer_functions[@backingInt(call.function)];
    const argument = try context.argument(lowering, lowering.program.functions.at(@backingInt(call.function)).output_type, lanes, lowering.buffer_calls.get(id).?);

    return @import("../value_call/root.zig").invocation(lowering, call, argument);
}
