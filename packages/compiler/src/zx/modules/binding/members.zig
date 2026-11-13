const std = @import("std");
const Self = @This();

default: ?*const @import("../function_import.zig") = null,
named: []const @import("../function_import.zig"),
pub fn names(self: Self, allocator: std.mem.Allocator) std.mem.Allocator.Error![]const []const u8 {
    const first: usize = @intFromBool(self.default != null);
    const result = try allocator.alloc([]const u8, first + self.named.len);

    if (self.default) |member| result[0] = member.name;
    for (self.named, result[first..]) |*member, *name| name.* = member.name;

    return result;
}

pub fn at(self: Self, row: usize) *const @import("../function_import.zig") {
    if (self.default) |member| return if (row == 0) member else &self.named[row - 1];

    return &self.named[row];
}
