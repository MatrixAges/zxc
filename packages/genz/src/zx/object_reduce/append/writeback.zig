const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");

pub fn replace(lowering: *Lower, type_id: ir.TypeId, source: *const node.Expression, path: []const u32, value: *const node.Expression) Lower.Error!*const node.Expression {
    if (path.len == 0) return value;

    return lowering.construct(type_id, try replaceLayout(lowering, type_id, source, path, value));
}

pub fn replaceLayout(lowering: *Lower, type_id: ir.TypeId, source: *const node.Expression, path: []const u32, value: *const node.Expression) Lower.Error!*const node.Expression {
    if (path.len == 0) return value;

    const updated = switch (lowering.program.typeOf(type_id)) {
        .object => |fields| blk: {
            const result = try lowering.allocator.alloc(node.Field, fields.len);

            for (fields, 0..) |field, index| {
                const existing = try lowering.field(source, field.name);

                result[index] = .{ .name = field.name, .value = if (index == path[0]) try replace(lowering, field.type_id, existing, path[1..], value) else existing };
            }

            break :blk try lowering.builder.expression(.{ .object = .{ .type_expr = lowering.layouts[@backingInt(type_id)], .fields = result } });
        },
        .tuple => |items| blk: {
            const result = try lowering.allocator.alloc(*const node.Expression, items.len);

            for (items, 0..) |item, index| {
                const existing = try lowering.field(source, try std.fmt.allocPrint(lowering.allocator, "{d}", .{index}));
                result[index] = if (index == path[0]) try replace(lowering, item, existing, path[1..], value) else existing;
            }

            break :blk try lowering.builder.expression(.{ .tuple = result });
        },
        else => unreachable,
    };

    return updated;
}
