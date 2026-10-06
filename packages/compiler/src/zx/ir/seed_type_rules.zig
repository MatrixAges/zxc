const std = @import("std");
const ir = @import("zx").ir;

pub fn validate(types: ir.TypeTable) bool {
    if (!ir.TypeTable.validStructure(types)) return false;

    const scalars = std.enums.values(ir.Scalar);

    if (types.count() < scalars.len) return false;

    for (0..types.count()) |index| {
        const value = types.at(index);

        if (index < scalars.len) {
            if (value != .scalar or value.scalar != scalars[index]) return false;

            continue;
        }

        switch (value) {
            .scalar => return false,
            .native_reference => |name| if (!@import("lint").checkName(name, .type_decl)) return false,
            .task => |task| {
                if (@backingInt(task.result) >= index or @backingInt(task.errors) >= index) return false;
                if (types.at(@backingInt(task.result)) == .task or types.at(@backingInt(task.errors)) != .error_set) return false;
            },
            .list, .optional => |child| {
                if (@backingInt(child) >= index or (value == .list and @backingInt(child) == 0)) return false;
                if (types.at(@backingInt(child)) == .task) return false;
            },
            .tuple => |children| for (0..children.len) |view_index| {
                const child = children.at(view_index);

                if (@backingInt(child) >= index) return false;
                if (types.at(@backingInt(child)) == .task) return false;
            },
            .object => |fields| for (0..fields.len, 0..) |item_index, field_index| {
                const field = fields.at(item_index);

                if (@backingInt(field.type_id) >= index or @backingInt(field.type_id) == 0 or field.name.len == 0) return false;
                if (types.at(@backingInt(field.type_id)) == .task) return false;
                if (field_index > 0 and !std.mem.lessThan(u8, fields.at(field_index - 1).name, field.name)) return false;
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
