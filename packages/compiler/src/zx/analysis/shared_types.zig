const zx = @import("zx");
const Types = @import("types.zig");
const Pool = @import("../modules/link/types.zig");
const Origins = @import("../modules/nominal_origins.zig");
pub const Shared = struct { origins: *Origins, origin: Origins.Origin };

pub fn resolve(types: *Types, first: usize, shared: Shared) zx.Error!void {
    var declared = Origins{ .allocator = types.allocator };

    try declared.items.appendTable(types.allocator, shared.origins.items.view());
    try declared.append(types.items.view(), first, shared.origin);

    var pool = Pool{ .allocator = types.allocator, .origins = shared.origins.* };

    try pool.items.appendDelta(types.allocator, types.items.view().prefix(first));

    const mapping = pool.appendFrom(types.allocator, types.items.view(), declared.items.view(), first) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return types.reporter.fail(.type_mismatch, .{ .start = 0, .end = 0 }, "shared nominal declaration has incompatible identity or members");
    };

    for (types.resolved.values()) |*id| id.* = mapping[@backingInt(id.*)];

    types.items = pool.items;
    shared.origins.* = pool.origins;
}
