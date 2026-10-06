const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn get(self: *Context, id: ir.TypeId) Lower.Error!*const node.Expression {
    const lowering = self.lowering;

    if (self.types.get(id)) |value| return value;

    const definition = switch (lowering.program.typeOf(id)) {
        .optional => |child| return lowering.builder.expression(.{ .optional_type = try get(self, child) }),
        .object => |fields| blk: {
            const items = try lowering.allocator.alloc(node.Field, fields.len);

            for (0..fields.len, items) |view_index, *item| {
                const field = fields.at(view_index);

                item.* = .{ .name = field.name, .value = try get(self, field.type_id) };
            }

            break :blk try lowering.builder.expression(.{ .struct_type = items });
        },
        .tuple => |children| blk: {
            const items = try lowering.allocator.alloc(*const node.Expression, children.len);

            for (0..children.len, items) |item_index, *item| {
                const child = children.at(item_index);
                item.* = try get(self, child);
            }

            break :blk try lowering.builder.expression(.{ .tuple_type = items });
        },
        else => return lowering.types[@backingInt(id)],
    };

    const name = try lowering.fresh("state_type");
    const value = try lowering.builder.identifier(name);

    try self.declarations.append(lowering.allocator, .{ .constant = .{ .name = name, .value = definition } });
    try self.types.put(lowering.allocator, id, value);

    return value;
}
