const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");

pub fn project(lowering: *Lower, type_id: ir.TypeId, source: *const node.Expression, path: []const u32) Lower.Error!*const node.Expression {
    var result = source;
    var selected = type_id;

    for (path) |part| switch (lowering.program.typeOf(selected)) {
        .object => |items| {
            result = try lowering.field(result, items.at(part).name);
            selected = items.at(part).type_id;
        },
        .tuple => |items| {
            result = try lowering.field(result, try std.fmt.allocPrint(lowering.allocator, "{d}", .{part}));
            selected = items.at(part);
        },
        else => unreachable,
    };

    return result;
}

pub fn replace(lowering: *Lower, type_id: ir.TypeId, source: *const node.Expression, path: []const u32, value: *const node.Expression) Lower.Error!*const node.Expression {
    if (path.len == 0) return value;

    return lowering.construct(type_id, try replaceLayout(lowering, type_id, source, path, value));
}

pub fn replaceLayout(lowering: *Lower, type_id: ir.TypeId, source: *const node.Expression, path: []const u32, value: *const node.Expression) Lower.Error!*const node.Expression {
    if (path.len == 0) return value;

    const updated = switch (lowering.program.typeOf(type_id)) {
        .object => |fields| blk: {
            const result = try lowering.allocator.alloc(node.Field, fields.len);

            for (0..fields.len, 0..) |view_index, index| {
                const field = fields.at(view_index);
                const existing = try lowering.field(source, field.name);
                result[index] = .{ .name = field.name, .value = if (index == path[0]) try replace(lowering, field.type_id, existing, path[1..], value) else existing };
            }

            break :blk try lowering.builder.expression(.{ .object = .{ .type_expr = lowering.layouts[@backingInt(type_id)], .fields = result } });
        },
        .tuple => |items| blk: {
            const result = try lowering.allocator.alloc(*const node.Expression, items.len);

            for (0..items.len, 0..) |item_index, index| {
                const item = items.at(item_index);
                const existing = try lowering.field(source, try std.fmt.allocPrint(lowering.allocator, "{d}", .{index}));
                result[index] = if (index == path[0]) try replace(lowering, item, existing, path[1..], value) else existing;
            }

            break :blk try @import("../../state_value/origin.zig").tuple(lowering, type_id, try lowering.builder.expression(.{ .tuple = result }));
        },
        else => unreachable,
    };

    return updated;
}
