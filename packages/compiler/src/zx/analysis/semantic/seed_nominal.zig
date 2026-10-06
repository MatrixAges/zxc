const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../../modules/nominal_origins.zig");

pub fn find(table: ir.TypeTable, bindings: Origins.Table, origin: Origins.Origin, value: ir.TypeValue) error{ConflictingNominalType}!?ir.TypeId {
    for (0..bindings.count()) |index| {
        const item = bindings.at(index);

        if (!std.mem.eql(u8, item.name, value.nominalName().?) or !Origins.same(item.origin, origin)) continue;

        const existing = table.at(@backingInt(item.type_id));

        if (std.meta.activeTag(existing) != std.meta.activeTag(value)) return error.ConflictingNominalType;

        if (value == .enumeration) {
            if (existing.enumeration.members.len != value.enumeration.members.len) return error.ConflictingNominalType;

            for (existing.enumeration.members, value.enumeration.members) |left, right| {
                if (!std.mem.eql(u8, left, right)) return error.ConflictingNominalType;
            }
        }

        return item.type_id;
    }

    return null;
}
