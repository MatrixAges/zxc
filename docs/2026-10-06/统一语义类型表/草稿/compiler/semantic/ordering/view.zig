const std = @import("std");
const Self = @This();

names: [][]const u8,
types: ?[]u32,
pub fn lessThan(self: Self, left: usize, right: usize) bool {
    return std.mem.lessThan(u8, self.names[left], self.names[right]);
}

pub fn swap(self: Self, left: usize, right: usize) void {
    std.mem.swap([]const u8, &self.names[left], &self.names[right]);

    if (self.types) |types| std.mem.swap(u32, &types[left], &types[right]);
}
