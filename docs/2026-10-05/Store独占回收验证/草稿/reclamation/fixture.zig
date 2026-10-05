const std = @import("std");
pub const State = @import("zxc_state");
const Self = @This();

allocator: std.mem.Allocator,
arena: *std.heap.ArenaAllocator,
state: *State,
pub fn init(allocator: std.mem.Allocator) !Self {
    const arena = try allocator.create(std.heap.ArenaAllocator);

    errdefer allocator.destroy(arena);

    arena.* = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const state = try allocator.create(State);

    errdefer allocator.destroy(state);

    state.* = .{ .arena = arena };

    try state.initialize();

    return .{ .allocator = allocator, .arena = arena, .state = state };
}

pub fn deinit(self: *Self) void {
    self.state.deinit();
    self.allocator.destroy(self.state);
    self.arena.deinit();
    self.allocator.destroy(self.arena);
}
