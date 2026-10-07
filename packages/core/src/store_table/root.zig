const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();

paths: []const []const u8 = &.{},
types: []const u32 = &.{},
handles: []const []const u8 = &.{},
readable: []const bool = &.{},
writable: []const bool = &.{},
pub fn count(self: Self) usize {
    return self.paths.len;
}

pub fn at(self: Self, index: usize) ir.StoreSlot {
    return .{ .path = self.paths[index], .type_id = @fromBackingInt(self.types[index]), .handle = self.handles[index], .readable = self.readable[index], .writable = self.writable[index] };
}

pub fn validStructure(self: Self) bool {
    const len = self.count();

    return len <= std.math.maxInt(u32) and self.types.len == len and self.handles.len == len and self.readable.len == len and self.writable.len == len;
}

pub fn fromValues(allocator: std.mem.Allocator, values: []const ir.StoreSlot) std.mem.Allocator.Error!Self {
    var storage: @import("storage.zig") = .{};

    errdefer storage.deinit(allocator);

    for (values) |value| try storage.append(allocator, value);

    return storage.finish(allocator);
}
