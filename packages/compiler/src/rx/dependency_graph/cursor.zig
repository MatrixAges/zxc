const std = @import("std");
const Node = @import("dsl").ast.Node;
const Self = @This();

pending: []const Node = &.{},
ancestors: std.ArrayList([]const Node) = .empty,
pub fn reset(self: *Self, root: *const Node) void {
    std.debug.assert(self.ancestors.items.len == 0);

    self.pending = @as(*const [1]Node, @ptrCast(root));
}

pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.ancestors.deinit(allocator);
}

pub fn next(self: *Self, allocator: std.mem.Allocator) std.mem.Allocator.Error!?*const Node {
    if (self.pending.len == 0) self.pending = self.ancestors.pop() orelse return null;

    const node = &self.pending[0];

    self.pending = self.pending[1..];

    if (node.children.len != 0) {
        if (self.pending.len != 0) try self.ancestors.append(allocator, self.pending);

        self.pending = node.children;
    }

    return node;
}
