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
            .native_reference => |name| if (!@import("lint").checkName(name, .type_decl)) return false,
            .task => |task| {
                if (@backingInt(task.result) >= index or @backingInt(task.errors) >= index) return false;
                if (types[@backingInt(task.result)] == .task or types[@backingInt(task.errors)] != .error_set) return false;
            },
            .list, .optional => |child| {
                if (@backingInt(child) >= index or (value == .list and @backingInt(child) == 0)) return false;
                if (types[@backingInt(child)] == .task) return false;
            },
            .tuple => |children| for (children) |child| {
                if (@backingInt(child) >= index) return false;
                if (types[@backingInt(child)] == .task) return false;
            },
            .object => |fields| for (fields, 0..) |field, field_index| {
                if (@backingInt(field.type_id) >= index or @backingInt(field.type_id) == 0 or field.name.len == 0) return false;
                if (types[@backingInt(field.type_id)] == .task) return false;
                if (field_index > 0 and !std.mem.lessThan(u8, fields[field_index - 1].name, field.name)) return false;
            },
            .error_set => |members| for (members, 0..) |member, member_index| {
                if (!@import("lint").checkName(member, .type_decl)) return false;
                if (member_index > 0 and !std.mem.lessThan(u8, members[member_index - 1], member)) return false;
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
