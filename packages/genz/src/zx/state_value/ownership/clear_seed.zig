const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const ownership = @import("../ownership.zig");

pub fn clear(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!void {
    if (!ownership.needed(self, id, type_id, slot)) return;

    const target = self.program.typeOf(type_id);

    if (self.state_plan.referenced(type_id)) {
        const copied = try @import("../reference.zig").copy(self, body, type_id, value);

        try clearFields(self, body, id, target.object, copied, slot);

        try body.append(self.allocator, .{ .assignment = .{
            .target = value,
            .value = try self.builder.expression(.{ .address_of = copied }),
        } });

        return;
    }

    switch (target) {
        .optional => |child| {
            var present: std.ArrayList(node.Statement) = .empty;
            const payload = try self.builder.expression(.{ .optional_unwrap = value });

            try clear(self, &present, id, child, payload, slot);

            try body.append(self.allocator, try self.builder.branch(
                try @import("../../intrinsics.zig").binary(self, .not_equal, value, try self.builder.expression(.null_value)),
                present.items,
                &.{},
            ));
        },
        .list => try body.append(self.allocator, .{ .assignment = .{
            .target = try self.field(value, "storage"),
            .value = try @import("../list.zig").weakened(self, value),
        } }),
        .object => |items| try clearFields(self, body, id, items, value, slot),
        .tuple => |children| {
            var offset = slot;

            for (0..children.len) |index| {
                const child = children.at(index);
                const source = try self.field(value, try std.fmt.allocPrint(self.allocator, "{d}", .{index}));

                try clear(self, body, id, child, source, offset);

                offset += ownership.count(self, child);
            }
        },
        else => unreachable,
    }
}

fn clearFields(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, items: anytype, value: node.ExpressionId, slot: u32) Lower.Error!void {
    var offset = slot;

    for (0..items.len) |index| {
        const field = items.at(index);

        try clear(self, body, id, field.type_id, try self.field(value, field.name), offset);

        offset += ownership.count(self, field.type_id);
    }
}
