const std = @import("std");
const ir = @import("../ir.zig");
const Self = @This();
pub const Ownership = enum { Copy, Borrowed, Owned };

names: []const []const u8 = &.{},
types: []const u32 = &.{},
span_start: []const u64 = &.{},
span_end: []const u64 = &.{},
ownership: []const Ownership = &.{},
pub fn count(self: Self) usize {
    return self.names.len;
}

pub fn at(self: Self, index: usize) ir.Symbol {
    return .{ .name = self.names[index], .type_id = @fromBackingInt(self.types[index]), .span = .{ .start = @intCast(self.span_start[index]), .end = @intCast(self.span_end[index]) }, .ownership = switch (self.ownership[index]) {
        .Copy => .copy,
        .Borrowed => .borrowed,
        .Owned => .owned,
    } };
}

pub fn get(self: Self, id: ir.SymbolId) ir.Symbol {
    return self.at(@backingInt(id));
}

pub fn validStructure(self: Self) bool {
    const len = self.count();

    if (len > std.math.maxInt(u32) or self.types.len != len or self.span_start.len != len or self.span_end.len != len or self.ownership.len != len) return false;

    for (self.span_start, self.span_end) |start, end| {
        if (start > std.math.maxInt(usize) or end > std.math.maxInt(usize)) return false;
    }

    return true;
}

pub fn fromValues(allocator: std.mem.Allocator, values: []const ir.Symbol) std.mem.Allocator.Error!Self {
    var storage: @import("storage.zig") = .{};

    errdefer storage.deinit(allocator);

    for (values) |value| try storage.append(allocator, value);

    return storage.finish(allocator);
}
