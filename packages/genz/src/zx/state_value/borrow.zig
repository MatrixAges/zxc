const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, storage: *std.ArrayList(node.Statement), body: *std.ArrayList(node.Statement), id: ir.TypeId, value: *const node.Expression) Lower.Error!*const node.Expression {
    if (!self.state_plan.represented(self.program, id)) return value;

    const layout = self.abi_layouts[@backingInt(id)];

    const result = switch (self.program.typeOf(id)) {
        .optional => |child| {
            var present: std.ArrayList(node.Statement) = .empty;
            const payload = try self.builder.expression(.{ .optional_unwrap = value });
            const converted = try lower(self, storage, &present, child, payload);

            return self.cast(self.abi_types[@backingInt(id)], try self.builder.expression(.{ .conditional = .{
                .condition = try @import("../intrinsics.zig").binary(self, .not_equal, value, try self.builder.expression(.null_value)),
                .yes = try @import("../aggregate.zig").finish(self, &present, converted),
                .no = try self.builder.expression(.null_value),
            } }));
        },
        .object => |fields| blk: {
            const items = try self.allocator.alloc(node.Field, fields.len);

            for (fields, items) |field, *item| item.* = .{
                .name = field.name,
                .value = try lower(self, storage, body, field.type_id, try self.field(value, field.name)),
            };

            break :blk try self.builder.expression(.{ .object = .{ .type_expr = layout, .fields = items } });
        },
        .tuple => |children| blk: {
            const items = try self.allocator.alloc(*const node.Expression, children.len);

            for (children, items, 0..) |child, *item, index| item.* = try lower(self, storage, body, child, try self.field(value, try std.fmt.allocPrint(self.allocator, "{d}", .{index})));

            break :blk try self.cast(layout, try self.builder.expression(.{ .tuple = items }));
        },
        else => unreachable,
    };

    const name = try self.fresh("state_borrow");
    const slot = try self.builder.identifier(name);

    try storage.append(self.allocator, .{ .variable = .{ .name = name, .type_expr = layout, .value = try self.builder.expression(.undefined_value) } });
    try body.append(self.allocator, .{ .assignment = .{ .target = slot, .value = result } });

    const origin = try self.field(value, try @import("origin.zig").name(self, id));

    return self.builder.expression(.{ .binary = .{ .operator = .coalesce, .left = origin, .right = try self.builder.expression(.{ .address_of = slot }) } });
}
