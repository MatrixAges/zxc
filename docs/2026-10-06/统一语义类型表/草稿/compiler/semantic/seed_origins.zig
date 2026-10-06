const std = @import("std");
const ir = @import("zx").ir;
const Origins = @import("../../modules/nominal_origins.zig");

pub fn valid(types: ir.TypeTable, values: Origins.Table) bool {
    if (!values.hasValidShape()) return false;

    for (0..values.count()) |index| {
        const item = values.at(index);
        const id = @backingInt(item.type_id);

        if (id >= types.count()) return false;

        const name = types.at(id).nominalName() orelse return false;

        if (types.at(id) == .native_reference and item.origin != .native) return false;
        if (!std.mem.eql(u8, name, item.name)) return false;

        for (0..index) |previous_index| {
            const previous = values.at(previous_index);

            if (previous.type_id == item.type_id) return false;
            if (Origins.same(previous.origin, item.origin) and std.mem.eql(u8, previous.name, item.name)) return false;
        }
    }

    return true;
}
