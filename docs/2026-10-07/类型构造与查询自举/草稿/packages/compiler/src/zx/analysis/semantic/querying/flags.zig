const std = @import("std");
const Self = @This();

pub const State = struct { values: []bool = &.{} };

allocator: std.mem.Allocator,
state: *State,
pub fn deinit(self: *const Self) void {
    self.allocator.free(self.state.values);
}
