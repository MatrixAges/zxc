const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Builder = @import("../object_reduce/append/builder.zig");
const Lane = @import("analysis/flow.zig").Lane;
const ir = @import("zx").ir;

pub fn typeOf(lowering: *Lower, lanes: []const Lane) Lower.Error!*const node.Expression {
    return typeFor(lowering, lowering.program.output_type, lanes);
}

/// Buffers parameter type of a function with the given output type and lanes.
pub fn typeFor(lowering: *Lower, output_type: ir.TypeId, lanes: []const Lane) Lower.Error!*const node.Expression {
    var fields: std.ArrayList(node.Field) = .empty;
    var key: std.ArrayList(u8) = .empty;

    for (lanes, 0..) |lane, index| {
        if (lane.rejection != null) continue;

        var selected = output_type;

        for (lane.output) |part| selected = switch (lowering.program.typeOf(selected)) {
            .object => |items| items.at(part).type_id,
            .tuple => |items| items.at(part),
            else => unreachable,
        };

        const element_id = lowering.program.typeOf(selected).list;
        const element = lowering.types[@backingInt(element_id)];
        const slot_type = try @import("slot.zig").typeOf(lowering, element);

        try fields.append(lowering.allocator, .{ .name = try name(lowering, index), .value = try lowering.builder.expression(.{ .optional_type = slot_type }) });
        try key.print(lowering.allocator, "{d}:{d};", .{ index, @backingInt(element_id) });
    }

    if (lowering.function_modules == null) return @import("types.zig").named(lowering, key.items, try fields.toOwnedSlice(lowering.allocator));

    return lowering.builder.expression(.{ .struct_type = try fields.toOwnedSlice(lowering.allocator) });
}

pub fn builder(lowering: *Lower, index: usize) Lower.Error!Builder {
    const slot = try lowering.field(try lowering.builder.identifier("buffers"), try name(lowering, index));
    const payload = try lowering.builder.expression(.{ .optional_unwrap = slot });

    return .{
        .buffer = try lowering.builder.expression(.{ .dereference = try lowering.field(payload, "buffer") }),
        .started = try lowering.builder.expression(.{ .dereference = try lowering.field(payload, "started") }),
        .enabled = try lowering.builder.expression(.{ .binary = .{ .operator = .not_equal, .left = slot, .right = try lowering.builder.expression(.null_value) } }),
        .slot = slot,
        .lane = index,
    };
}

pub fn argument(lowering: *Lower, output_type: ir.TypeId, lanes: []const Lane, slots: []const ?Builder) Lower.Error!*const node.Expression {
    if (try forwardsAll(lowering, output_type, lanes, slots)) {
        lowering.uses_buffers = true;

        return lowering.builder.identifier("buffers");
    }

    var fields: std.ArrayList(node.Field) = .empty;

    for (lanes, slots, 0..) |lane, slot, index| {
        if (lane.rejection != null) continue;

        const value = if (slot) |source| blk: {
            if (source.slot) |forwarded| {
                lowering.uses_buffers = true;

                break :blk forwarded;
            }

            const members = try lowering.allocator.dupe(node.Field, &.{
                .{ .name = "buffer", .value = try lowering.builder.expression(.{ .address_of = source.buffer }) },
                .{ .name = "started", .value = try lowering.builder.expression(.{ .address_of = source.started }) },
            });

            const payload = try lowering.builder.expression(.{ .object = .{ .fields = members } });

            if (source.enabled) |enabled| {
                lowering.uses_buffers = true;

                break :blk try lowering.builder.expression(.{ .conditional = .{ .condition = enabled, .yes = payload, .no = try lowering.builder.expression(.null_value) } });
            }

            break :blk payload;
        } else try lowering.builder.expression(.null_value);

        try fields.append(lowering.allocator, .{ .name = try name(lowering, index), .value = value });
    }

    return lowering.builder.expression(.{ .object = .{ .fields = try fields.toOwnedSlice(lowering.allocator) } });
}

pub fn name(lowering: *Lower, index: usize) Lower.Error![]const u8 {
    return std.fmt.allocPrint(lowering.allocator, "lane_{d}", .{index});
}

/// True when every lane of the callee receives the caller's slot of the same lane and both share one named buffers type.
fn forwardsAll(lowering: *Lower, output_type: ir.TypeId, lanes: []const Lane, slots: []const ?Builder) Lower.Error!bool {
    const current = lowering.buffered_type orelse return false;

    if (lowering.function_modules != null or current.* != .identifier) return false;

    for (lanes, slots, 0..) |lane, slot, index| {
        if (lane.rejection != null) continue;

        const source = slot orelse return false;

        if (source.slot == null or source.lane != index) return false;
    }

    const callee = try typeFor(lowering, output_type, lanes);

    return std.mem.eql(u8, callee.identifier, current.identifier);
}
