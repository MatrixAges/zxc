const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Builder = @import("../../object_reduce/append/builder.zig");
const aggregate = @import("../../aggregate.zig");
const context = @import("../context.zig");

pub fn prepare(lowering: *Lower, body: *std.ArrayList(node.Statement), call: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call"), argument: **const node.Expression) Lower.Error!?*const node.Expression {
    const lanes = lowering.buffer_functions[@backingInt(call.function)];
    var slots: ?[]?Builder = null;

    for (lanes, 0..) |lane, index| {
        if (lane.rejection != null or lane.appends.len != 0 or lane.pops.len != 0 or lane.calls.len != 0 or lane.updates.len == 0) continue;
        if (!try @import("exclusive.zig").check(lowering, call.argument, lane.input)) continue;

        const input_type = lowering.program.functions.at(@backingInt(call.function)).input_type;
        var type_id = input_type;

        for (lane.input) |part| {
            type_id = switch (lowering.program.typeOf(type_id)) {
                .object => |fields| fields.at(part).type_id,
                .tuple => |items| items.at(part),
                else => unreachable,
            };
        }

        const child = lowering.program.typeOf(type_id).list;

        if (@import("../../iteration_layout.zig").represented(lowering.program, child)) continue;

        if (slots == null) {
            argument.* = try aggregate.bind(lowering, body, argument.*);
            slots = try lowering.allocator.alloc(?Builder, lanes.len);

            @memset(slots.?, null);
        }

        const element = lowering.types[@backingInt(child)];
        const source = try aggregate.bind(lowering, body, try @import("../../object_reduce/append/writeback.zig").project(lowering, input_type, argument.*, lane.input));
        const name = try lowering.fresh("transferred_items");
        const started = try lowering.fresh("transferred_started");
        const buffer_type = try lowering.call(try lowering.field(try lowering.builder.identifier("std"), "ArrayList"), &.{element}, false);
        const owned = try lowering.call(try lowering.field(buffer_type, "fromOwnedSlice"), &.{try lowering.builtin(.constCast, &.{source})}, false);

        try body.append(lowering.allocator, .{ .variable = .{ .name = name, .type_expr = buffer_type, .value = owned } });
        try body.append(lowering.allocator, .{ .variable = .{ .name = started, .value = try lowering.builder.expression(.{ .boolean = true }) } });

        slots.?[index] = .{ .buffer = try lowering.builder.identifier(name), .started = try lowering.builder.identifier(started) };
    }

    if (slots) |selected| return try context.argument(lowering, lanes, selected);

    return null;
}
