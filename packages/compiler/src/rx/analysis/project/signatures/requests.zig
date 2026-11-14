const std = @import("std");
const Id = @import("../../inference/types.zig").Id;
const Self = @This();
pub const Binding = struct { name: []const u8, value: Id };
pub const Task = struct { id: usize, value: Id };

bindings: std.MultiArrayList(Binding) = .empty,
tasks: std.MultiArrayList(Task) = .empty,
pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.tasks.deinit(allocator);
}
