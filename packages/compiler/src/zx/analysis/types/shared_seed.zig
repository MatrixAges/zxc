const zx = @import("zx");
const Types = @import("../types.zig");
const Pool = @import("../../modules/link/types.zig");

pub fn resolve(types: *Types, first: usize, shared: Types.Shared) zx.Error!void {
    const origin_count = shared.origins.items.view().count();

    errdefer shared.origins.items.retainPrefix(origin_count);

    try shared.origins.append(types.items.view(), first, shared.origin);

    var pool = Pool{ .allocator = types.allocator, .items = types.items, .origins = shared.origins.* };

    types.items = .{};
    shared.origins.items = .{};

    defer {
        types.items = pool.items;
        shared.origins.* = pool.origins;
    }

    const mapping = pool.compact(types.allocator, first, origin_count) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return types.reporter.fail(.type_mismatch, .{ .start = 0, .end = 0 }, "shared nominal declaration has incompatible identity or members");
    };

    for (types.resolved.values()) |*id| id.* = mapping[@backingInt(id.*)];
}
