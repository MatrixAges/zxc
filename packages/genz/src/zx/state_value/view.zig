const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const types = @import("../types.zig");

pub fn convert(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, input: bool) Lower.Error!node.ExpressionId {
    if (!self.state_plan.represented(self.program, id)) return value;

    if (self.program.typeOf(id) == .list) {
        if (@import("elements.zig").inlineStored(self, id)) return if (input) @import("list.zig").borrowed(self, id, value) else self.field(value, "items");

        return @import("elements.zig").convert(self, body, id, value, input);
    }

    const private = try types.get(self, self.state_types, id);
    const public = try types.get(self, self.view_types, id);

    if (private == public) return value;

    const target = if (input) private else public;

    return switch (self.program.typeOf(id)) {
        .optional => |child| optional: {
            var present: std.ArrayList(node.Statement) = .empty;
            const payload = try self.builder.expression(.{ .optional_unwrap = value });
            const converted = try convert(self, &present, child, payload, input);

            break :optional self.cast(target, try self.builder.expression(.{ .conditional = .{
                .condition = try @import("../intrinsics.zig").binary(self, .not_equal, value, try self.builder.expression(.null_value)),
                .yes = try aggregate.finish(self, &present, converted),
                .no = try self.builder.expression(.null_value),
            } }));
        },
        .object => |fields| object: {
            const items = try self.allocator.alloc(node.Field, fields.len + 1);

            for (items[0..fields.len], 0..) |*item, index| {
                const field = fields.at(index);

                item.* = .{ .name = field.name, .value = try convert(self, body, field.type_id, try self.field(value, field.name), input) };
            }

            const origin = try @import("origin.zig").name(self, id);
            items[fields.len] = .{ .name = origin, .value = try self.field(value, origin) };

            break :object self.builder.expression(.{ .object = .{ .type_expr = target, .fields = items } });
        },
        .tuple => |children| tuple: {
            const items = try self.allocator.alloc(node.ExpressionId, children.len + 1);

            for (items, 0..) |*item, index| {
                const field = try self.field(value, try std.fmt.allocPrint(self.allocator, "{d}", .{index}));

                item.* = if (index == children.len) field else try convert(self, body, children.at(index), field, input);
            }

            break :tuple self.cast(target, try self.builder.expression(.{ .tuple = items }));
        },
        else => unreachable,
    };
}
