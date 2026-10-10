const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Builder = @import("../../object_reduce/append/builder.zig");
const aggregate = @import("../../aggregate.zig");
const context = @import("../context.zig");
const Call = @FieldType(@FieldType(ir.ExpressionRow, "value"), "call");

pub fn select(lowering: *Lower, call: Call) Lower.Error!?[]const bool {
    const lanes = lowering.buffer_functions[@backingInt(call.function)];
    const input = lowering.program.functions.at(@backingInt(call.function)).input_type;
    var selected: ?[]bool = null;

    for (lanes, lowering.transfer_functions[@backingInt(call.function)], 0..) |lane, capability, index| {
        if (!capability.writable) continue;
        if (@import("../../iteration_layout.zig").represented(lowering.program, child(lowering.program, input, lane.input))) continue;
        if (!try @import("exclusive.zig").check(lowering, call.argument, lane.input)) continue;

        if (selected == null) {
            selected = try lowering.allocator.alloc(bool, lanes.len);

            @memset(selected.?, false);
        }

        selected.?[index] = true;
    }

    return selected;
}

pub fn prepare(lowering: *Lower, body: *std.ArrayList(node.Statement), call: Call, argument: **const node.Expression, selected: []const bool) Lower.Error!*const node.Expression {
    const lanes = lowering.buffer_functions[@backingInt(call.function)];
    const input = lowering.program.functions.at(@backingInt(call.function)).input_type;
    const slots = try lowering.allocator.alloc(?Builder, lanes.len);

    @memset(slots, null);

    argument.* = try aggregate.bind(lowering, body, argument.*);

    for (lanes, selected, 0..) |lane, included, index| {
        if (!included) continue;

        const element = lowering.types[@backingInt(child(lowering.program, input, lane.input))];
        const source = try aggregate.bind(lowering, body, try @import("../../object_reduce/append/writeback.zig").project(lowering, input, argument.*, lane.input));
        const name = try lowering.fresh("transferred_items");
        const started = try lowering.fresh("transferred_started");
        const buffer_type = try lowering.call(try lowering.field(try lowering.builder.identifier("std"), "ArrayList"), &.{element}, false);
        const owned = try lowering.call(try lowering.field(buffer_type, "fromOwnedSlice"), &.{try lowering.builtin(.constCast, &.{source})}, false);

        try body.append(lowering.allocator, .{ .variable = .{ .name = name, .type_expr = buffer_type, .value = owned } });
        try body.append(lowering.allocator, .{ .variable = .{ .name = started, .value = try lowering.builder.expression(.{ .boolean = true }) } });

        slots[index] = .{ .buffer = try lowering.builder.identifier(name), .started = try lowering.builder.identifier(started) };
    }

    return context.argument(lowering, lowering.program.functions.at(@backingInt(call.function)).output_type, lanes, slots);
}

fn child(program: ir.Program, input: ir.TypeId, path: []const u32) ir.TypeId {
    var current = input;

    for (path) |part| {
        current = switch (program.typeOf(current)) {
            .object => |fields| fields.at(part).type_id,
            .tuple => |items| items.at(part),
            else => unreachable,
        };
    }

    return program.typeOf(current).list;
}
