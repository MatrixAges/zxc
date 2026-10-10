const std = @import("std");
const ir = @import("fixture.zig").ir;

pub fn same(left: ir.TypeTable, left_id: ir.TypeId, right: ir.TypeTable, right_id: ir.TypeId) !void {
    const a = left.get(left_id);
    const b = right.get(right_id);

    try std.testing.expectEqual(std.meta.activeTag(a), std.meta.activeTag(b));

    switch (a) {
        .scalar => |value| try std.testing.expectEqual(value, b.scalar),
        .list => |child| try same(left, child, right, b.list),
        .object => |fields| {
            try std.testing.expectEqual(fields.len, b.object.len);

            for (0..fields.len) |index| {
                const field = fields.at(index);
                const other = b.object.at(index);

                try std.testing.expectEqualStrings(field.name, other.name);
                try same(left, field.type_id, right, other.type_id);
            }
        },
        .enumeration => |value| {
            try std.testing.expectEqualStrings(value.name, b.enumeration.name);
            try std.testing.expectEqual(value.members.len, b.enumeration.members.len);
            for (value.members, b.enumeration.members) |name, other| try std.testing.expectEqualStrings(name, other);
        },
        else => return error.UnexpectedFixtureType,
    }
}
