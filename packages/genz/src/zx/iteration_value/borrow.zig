const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn lower(self: *Context, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: *const node.Expression) Lower.Error!*const node.Expression {
    return borrow(self, body, id, value, null);
}

fn borrow(self: *Context, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: *const node.Expression, guard: ?*const node.Expression) Lower.Error!*const node.Expression {
    const lowering = self.lowering;
    const layout = lowering.layouts[@backingInt(id)];

    const result = switch (lowering.program.typeOf(id)) {
        .optional => |child| {
            if (!@import("../iteration_layout.zig").represented(lowering.program, child)) return value;

            const present = try @import("../intrinsics.zig").binary(lowering, .not_equal, value, try lowering.builder.expression(.null_value));
            const condition = if (guard) |parent| try @import("../intrinsics.zig").binary(lowering, .logical_and, parent, present) else present;
            const payload = try borrow(self, body, child, try lowering.builder.expression(.{ .optional_unwrap = value }), condition);

            return lowering.cast(lowering.types[@backingInt(id)], try lowering.builder.expression(.{ .conditional = .{
                .condition = condition,
                .yes = payload,
                .no = try lowering.builder.expression(.null_value),
            } }));
        },
        .object => |fields| blk: {
            const items = try lowering.allocator.alloc(node.Field, fields.len);

            for (fields, items) |field, *item| item.* = .{
                .name = field.name,
                .value = try borrow(self, body, field.type_id, try lowering.field(value, field.name), guard),
            };

            break :blk try lowering.builder.expression(.{ .object = .{ .type_expr = layout, .fields = items } });
        },
        .tuple => |children| blk: {
            const items = try lowering.allocator.alloc(*const node.Expression, children.len);

            for (children, items, 0..) |child, *item, index| {
                const name = try std.fmt.allocPrint(lowering.allocator, "{d}", .{index});
                item.* = try borrow(self, body, child, try lowering.field(value, name), guard);
            }

            break :blk try lowering.cast(layout, try lowering.builder.expression(.{ .tuple = items }));
        },
        else => return value,
    };

    const initializer = if (guard) |condition| try lowering.builder.expression(.{ .conditional = .{ .condition = condition, .yes = result, .no = try lowering.builder.expression(.undefined_value) } }) else result;
    const saved = try aggregate.bind(lowering, body, initializer);

    return lowering.builder.expression(.{ .address_of = saved });
}
