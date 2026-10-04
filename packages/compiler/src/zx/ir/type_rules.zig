const std = @import("std");
const ir = @import("zx").ir;

pub fn validate(types: []const ir.Type) bool {
    const scalars = std.enums.values(ir.Scalar);

    if (types.len < scalars.len) return false;

    for (types, 0..) |value, index| {
        if (index < scalars.len) {
            if (value != .scalar or value.scalar != scalars[index]) return false;

            continue;
        }

        switch (value) {
            .scalar => return false,
            .list, .optional => |child| {
                if (@intFromEnum(child) >= index or (value == .list and @intFromEnum(child) == 0)) return false;
            },
            .tuple => |children| for (children) |child| {
                if (@intFromEnum(child) >= index) return false;
            },
            .object => |fields| for (fields, 0..) |field, field_index| {
                if (@intFromEnum(field.type_id) >= index or @intFromEnum(field.type_id) == 0 or field.name.len == 0) return false;
                if (field_index > 0 and !std.mem.lessThan(u8, fields[field_index - 1].name, field.name)) return false;
            },
            .enumeration => |enumeration| {
                if (enumeration.name.len == 0 or enumeration.members.len == 0) return false;

                for (enumeration.members, 0..) |member, member_index| {
                    if (member.len == 0) return false;

                    for (enumeration.members[0..member_index]) |previous| {
                        if (std.mem.eql(u8, member, previous)) return false;
                    }
                }
            },
        }
    }

    return true;
}
