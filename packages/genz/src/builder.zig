const std = @import("std");
const node = @import("node.zig");
const Self = @This();

allocator: std.mem.Allocator,
pub fn expression(self: Self, value: node.Expression) std.mem.Allocator.Error!*const node.Expression {
    const result = try self.allocator.create(node.Expression);

    result.* = value;

    return result;
}

pub fn identifier(self: Self, name: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .identifier = name });
}

pub fn integer(self: Self, value: u64) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .integer = value });
}

pub fn string(self: Self, value: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .string = value });
}
