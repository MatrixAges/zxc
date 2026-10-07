const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();

names: []const []const u8 = &.{},
type_ids: []const u32 = &.{},
pub fn count(self: Self) usize {
    return self.names.len;
}

pub fn at(self: Self, index: usize) ir.Export {
    return .{ .name = self.names[index], .type_id = @fromBackingInt(self.type_ids[index]) };
}

pub fn validStructure(self: Self) bool {
    return self.names.len == self.type_ids.len and self.count() <= std.math.maxInt(u32);
}

pub fn fromValues(allocator: std.mem.Allocator, values: []const ir.Export) std.mem.Allocator.Error!Self {
    if (values.len > std.math.maxInt(u32)) return error.OutOfMemory;

    const names = try allocator.alloc([]const u8, values.len);

    errdefer allocator.free(names);

    const ids = try allocator.alloc(u32, values.len);

    for (values, names, ids) |value, *name, *id| {
        name.* = value.name;
        id.* = @backingInt(value.type_id);
    }

    return .{ .names = names, .type_ids = ids };
}
