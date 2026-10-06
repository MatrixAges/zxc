const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

names: [][]const u8,
types: []u32,
pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    const names = try allocator.alloc([]const u8, count);

    errdefer allocator.free(names);

    return .{ .names = names, .types = try allocator.alloc(u32, count) };
}

pub fn set(self: Self, index: usize, name: []const u8, type_id: ir.TypeId) void {
    self.names[index] = name;
    self.types[index] = @backingInt(type_id);
}

pub fn prefix(self: Self, count: usize) Self {
    return .{ .names = self.names[0..count], .types = self.types[0..count] };
}

pub fn view(self: Self) ir.TypeFields {
    return .{ .names = self.names, .types = self.types, .len = self.names.len };
}

pub fn sort(self: Self) std.mem.Allocator.Error!void {
    try @import("../semantic/ordering.zig").sort(self.names, self.types);
}
