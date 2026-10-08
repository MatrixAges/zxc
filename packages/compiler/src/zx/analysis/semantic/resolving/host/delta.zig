const std = @import("std");
const zx = @import("zx");
const Types = @import("../../../types.zig");

pub fn apply(types: *Types, result: anytype) zx.Error!zx.ir.TypeId {
    var delta: zx.ir.TypeTable = undefined;

    inline for (@typeInfo(zx.ir.TypeTable).@"struct".field_names) |name| @field(delta, name) = @field(result.delta.*, name);

    const labels = try copy(types.allocator, delta.labels);

    defer types.allocator.free(labels);
    errdefer release(types.allocator, labels);

    const fields = try copy(types.allocator, delta.field_names);

    defer types.allocator.free(fields);
    errdefer release(types.allocator, fields);

    const names = try copy(types.allocator, delta.names);

    defer types.allocator.free(names);
    errdefer release(types.allocator, names);

    delta.labels = labels;
    delta.field_names = fields;
    delta.names = names;

    if (result.cache.names.len > std.math.maxInt(u32)) return error.OutOfMemory;
    try types.resolved.ensureUnusedCapacity(types.allocator, @intCast(result.cache.names.len));
    try types.items.appendDelta(types.allocator, delta);
    for (result.cache.names, result.cache.ids) |name, id| types.resolved.putAssumeCapacity(name, @fromBackingInt(id));

    return @fromBackingInt(result.id);
}

fn copy(allocator: std.mem.Allocator, source: []const []const u8) std.mem.Allocator.Error![][]const u8 {
    const result = try allocator.alloc([]const u8, source.len);
    var copied: usize = 0;

    errdefer allocator.free(result);
    errdefer release(allocator, result[0..copied]);

    for (source, result) |name, *owned| {
        owned.* = try allocator.dupe(u8, name);
        copied += 1;
    }

    return result;
}

fn release(allocator: std.mem.Allocator, names: []const []const u8) void {
    for (names) |name| allocator.free(name);
}
