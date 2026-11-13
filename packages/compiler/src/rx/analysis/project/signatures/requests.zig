const std = @import("std");
const Id = @import("../../inference/types.zig").Id;
const Self = @This();
pub const Binding = struct { name: []const u8, value: Id };
pub const Task = struct { id: usize, value: Id };

bindings: std.ArrayList(Binding) = .empty,
tasks: std.ArrayList(Task) = .empty,
pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
    self.bindings.deinit(allocator);
    self.tasks.deinit(allocator);
}
