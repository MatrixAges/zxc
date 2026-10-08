const zx = @import("zx");
const data = @import("nominal_data");
const Types = @import("../../../types.zig");

pub fn apply(types: *Types, result: anytype) zx.Error!zx.ir.TypeId {
    const origin: ?data.Origin = if (types.shared) |shared| prepared: {
        if (result.origins.ids.len == 0) break :prepared null;
        try shared.origins.items.ensureUnusedCapacity(types.allocator, result.origins.ids.len);

        break :prepared try data.copy(types.allocator, shared.origin);
    } else null;

    errdefer if (origin) |owned| switch (owned) {
        .source, .native => |value| types.allocator.free(value),
        .external => |value| {
            types.allocator.free(value.module);
            types.allocator.free(value.member);
        },
    };

    const id = try @import("delta.zig").apply(types, result);

    if (origin) |owned| {
        for (result.origins.ids) |type_id| {
            types.shared.?.origins.items.appendAssumeCapacity(.{
                .type_id = @fromBackingInt(type_id),
                .origin = owned,
                .name = types.items.view().at(type_id).nominalName().?,
            });
        }
    }

    return id;
}
