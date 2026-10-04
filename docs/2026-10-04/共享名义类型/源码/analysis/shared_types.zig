const zx = @import("zx");
const Types = @import("types.zig");
const Pool = @import("../modules/link/types.zig");
const Origins = @import("../modules/nominal_origins.zig");
pub const Shared = struct { origins: *Origins, origin: Origins.Origin };

pub fn resolve(types: *Types, first: usize, shared: Shared) zx.Error!void {
    var declared = Origins{ .allocator = types.allocator };

    try declared.items.appendSlice(types.allocator, shared.origins.items.items);
    try declared.append(types.items.items, first, shared.origin);

    var pool = Pool{ .allocator = types.allocator, .origins = shared.origins.* };

    try pool.items.appendSlice(types.allocator, types.items.items[0..first]);

    const mapping = pool.appendFrom(types.allocator, types.items.items, declared.items.items, first) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return types.reporter.fail(.type_mismatch, .{ .start = 0, .end = 0 }, "shared nominal declaration has incompatible identity or members");
    };

    var resolved = types.resolved.valueIterator();

    while (resolved.next()) |id| id.* = mapping[@intFromEnum(id.*)];

    types.items = pool.items;
    shared.origins.* = pool.origins;
}
