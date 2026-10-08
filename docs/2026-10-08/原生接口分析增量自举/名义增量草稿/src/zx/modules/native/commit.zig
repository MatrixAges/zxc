const zx = @import("zx");
const data = @import("nominal_data");
const Types = @import("../../analysis/types.zig");

pub fn apply(types: *Types, result: anytype) zx.Error!void {
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

    _ = try @import("../../analysis/semantic/resolving/host/commit.zig").apply(types, .{ .delta = result.delta, .cache = result.cache, .id = @as(u32, 0) });

    if (origin) |owned| {
        for (result.origins.ids) |id| {
            types.shared.?.origins.items.appendAssumeCapacity(.{
                .type_id = @fromBackingInt(id),
                .origin = owned,
                .name = types.items.view().at(id).nominalName().?,
            });
        }
    }
}
