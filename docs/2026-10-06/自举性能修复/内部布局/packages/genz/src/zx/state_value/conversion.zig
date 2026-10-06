const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
pub const Mode = enum { value, value_layout, pointer, layout, borrow };

pub fn convert(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: *const node.Expression, mode: Mode) Lower.Error!*const node.Expression {
    if (!self.state_plan.represented(self.program, id)) return value;
    if (mode == .borrow) return @import("borrow.zig").lower(self, body, body, id, value);

    const index = @backingInt(id);
    const input = mode == .value or mode == .value_layout;
    const layout = if (input) self.state_layouts[index] else self.abi_layouts[index];
    const child_mode: Mode = if (input) .value else .pointer;
    var fallback: std.ArrayList(node.Statement) = .empty;

    const result = switch (self.program.typeOf(id)) {
        .optional => |child| {
            var present_body: std.ArrayList(node.Statement) = .empty;
            const payload = try self.builder.expression(.{ .optional_unwrap = value });
            const converted = try convert(self, &present_body, child, payload, child_mode);

            return self.cast(if (input) self.state_types[index] else self.abi_types[index], try self.builder.expression(.{ .conditional = .{
                .condition = try @import("../intrinsics.zig").binary(self, .not_equal, value, try self.builder.expression(.null_value)),
                .yes = try aggregate.finish(self, &present_body, converted),
                .no = try self.builder.expression(.null_value),
            } }));
        },
        .object => |fields| blk: {
            const items = try self.allocator.alloc(node.Field, fields.len + @intFromBool(input));

            for (fields, items[0..fields.len]) |field, *item| item.* = .{
                .name = field.name,
                .value = try convert(self, &fallback, field.type_id, try self.field(value, field.name), child_mode),
            };

            if (input) items[fields.len] = .{
                .name = try @import("origin.zig").name(self, id),
                .value = if (mode == .value_layout) try self.builder.expression(.{ .address_of = value }) else value,
            };

            break :blk try self.builder.expression(.{ .object = .{ .type_expr = layout, .fields = items } });
        },
        .tuple => |children| blk: {
            const items = try self.allocator.alloc(*const node.Expression, children.len + @intFromBool(input));

            for (children, items[0..children.len], 0..) |child, *item, position| {
                const name = try std.fmt.allocPrint(self.allocator, "{d}", .{position});
                item.* = try convert(self, &fallback, child, try self.field(value, name), child_mode);
            }

            if (input) items[children.len] = if (mode == .value_layout) try self.builder.expression(.{ .address_of = value }) else value;

            break :blk try self.cast(layout, try self.builder.expression(.{ .tuple = items }));
        },
        else => unreachable,
    };

    if (input) return result;

    const created = if (mode == .layout) result else blk: {
        const pointer = try aggregate.bind(self, &fallback, try self.call(try self.field(try self.builder.identifier("allocator"), "create"), &.{layout}, true));

        try fallback.append(self.allocator, .{ .assignment = .{ .target = try self.builder.expression(.{ .dereference = pointer }), .value = result } });

        break :blk try self.cast(self.abi_types[index], pointer);
    };

    const origin = try self.field(value, try @import("origin.zig").name(self, id));
    const existing = try self.builder.expression(.{ .optional_unwrap = origin });

    return self.builder.expression(.{ .conditional = .{
        .condition = try @import("../intrinsics.zig").binary(self, .not_equal, origin, try self.builder.expression(.null_value)),
        .yes = if (mode == .layout) try self.builder.expression(.{ .dereference = existing }) else existing,
        .no = try aggregate.finish(self, &fallback, created),
    } });
}
