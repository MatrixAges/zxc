const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Builder = @import("../object_reduce/append/builder.zig");
const Lane = @import("analysis/flow.zig").Lane;

pub fn typeOf(lowering: *Lower, lanes: []const Lane) Lower.Error!*const node.Expression {
    var fields: std.ArrayList(node.Field) = .empty;

    for (lanes, 0..) |lane, index| {
        if (lane.rejection != null) continue;

        var selected = lowering.program.output_type;

        for (lane.output) |part| selected = switch (lowering.program.typeOf(selected)) {
            .object => |items| items.at(part).type_id,
            .tuple => |items| items.at(part),
            else => unreachable,
        };

        const element = lowering.types[@backingInt(lowering.program.typeOf(selected).list)];
        const buffer_type = try lowering.call(try lowering.field(try lowering.builder.identifier("std"), "ArrayList"), &.{element}, false);

        const slot_fields = try lowering.allocator.dupe(node.Field, &.{
            .{ .name = "buffer", .value = try lowering.builder.expression(.{ .pointer = buffer_type }) },
            .{ .name = "started", .value = try lowering.builder.expression(.{ .pointer = try lowering.builder.expression(.{ .primitive = .bool }) }) },
        });

        try fields.append(lowering.allocator, .{ .name = try name(lowering, index), .value = try lowering.builder.expression(.{ .optional_type = try lowering.builder.expression(.{ .struct_type = slot_fields }) }) });
    }

    return lowering.builder.expression(.{ .struct_type = try fields.toOwnedSlice(lowering.allocator) });
}

pub fn builder(lowering: *Lower, index: usize) Lower.Error!Builder {
    const slot = try lowering.field(try lowering.builder.identifier("buffers"), try name(lowering, index));
    const payload = try lowering.builder.expression(.{ .optional_unwrap = slot });

    return .{
        .buffer = try lowering.builder.expression(.{ .dereference = try lowering.field(payload, "buffer") }),
        .started = try lowering.builder.expression(.{ .dereference = try lowering.field(payload, "started") }),
        .enabled = try lowering.builder.expression(.{ .binary = .{ .operator = .not_equal, .left = slot, .right = try lowering.builder.expression(.null_value) } }),
    };
}

pub fn argument(lowering: *Lower, lanes: []const Lane, slots: []const ?Builder) Lower.Error!*const node.Expression {
    var fields: std.ArrayList(node.Field) = .empty;

    for (lanes, slots, 0..) |lane, slot, index| {
        if (lane.rejection != null) continue;

        const value = if (slot) |source| blk: {
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
