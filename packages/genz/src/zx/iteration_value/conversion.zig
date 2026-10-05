const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn convert(self: *Context, id: ir.TypeId, value: *const node.Expression, output: bool) Lower.Error!*const node.Expression {
    const lowering = self.lowering;
    const layout = if (output) lowering.layouts[@backingInt(id)] else try @import("types.zig").get(self, id);

    const result = switch (lowering.program.typeOf(id)) {
        .optional => |child| {
            const present = try @import("../intrinsics.zig").binary(lowering, .not_equal, value, try lowering.builder.expression(.null_value));
            const payload = try lowering.builder.expression(.{ .optional_unwrap = value });
            const optional_type = if (output) lowering.types[@backingInt(id)] else layout;

            return lowering.cast(optional_type, try lowering.builder.expression(.{ .conditional = .{
                .condition = present,
                .yes = try convert(self, child, payload, output),
                .no = try lowering.builder.expression(.null_value),
            } }));
        },
        .object => |fields| blk: {
            const items = try lowering.allocator.alloc(node.Field, fields.len);

            for (fields, items) |field, *item| item.* = .{
                .name = field.name,
                .value = try convert(self, field.type_id, try lowering.field(value, field.name), output),
            };

            break :blk try lowering.builder.expression(.{ .object = .{ .type_expr = layout, .fields = items } });
        },
        .tuple => |children| blk: {
            const items = try lowering.allocator.alloc(*const node.Expression, children.len);

            for (children, items, 0..) |child, *item, index| {
                const name = try std.fmt.allocPrint(lowering.allocator, "{d}", .{index});
                item.* = try convert(self, child, try lowering.field(value, name), output);
            }

            break :blk try lowering.cast(layout, try lowering.builder.expression(.{ .tuple = items }));
        },
        else => return value,
    };

    return if (output) lowering.construct(id, result) else result;
}
