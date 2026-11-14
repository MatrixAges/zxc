const std = @import("std");
const zx = @import("zx");
const Types = @import("../../../types.zig");
const publication = @import("../../merging/commit.zig");

pub fn apply(types: *Types, result: anytype) zx.Error!zx.ir.TypeId {
    if (result.cache.names.len > std.math.maxInt(u32)) return error.OutOfMemory;
    try types.resolved.ensureUnusedCapacity(types.allocator, @intCast(result.cache.names.len));
    try publication.appendTypes(types.allocator, &types.items, result.delta.*);
    for (result.cache.names, result.cache.ids) |name, id| types.resolved.putAssumeCapacity(name, @fromBackingInt(id));

    return @fromBackingInt(result.id);
}
