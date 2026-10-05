const std = @import("std");
pub const State = @import("zxc_state");
const Self = @This();

allocator: std.mem.Allocator,
arena: *std.heap.ArenaAllocator,
state: State,
pub fn init(allocator: std.mem.Allocator) !Self {
    const arena = try allocator.create(std.heap.ArenaAllocator);

    errdefer allocator.destroy(arena);

    arena.* = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    var state = State{ .arena = arena };

    try state.initialize();

    return .{ .allocator = allocator, .arena = arena, .state = state };
}

pub fn deinit(self: *Self) void {
    self.state.deinit();
    self.arena.deinit();
    self.allocator.destroy(self.arena);
}

pub fn left(request: *State.Request, value: u64, history: []const u64) !void {
    const candidate = try request.arena.allocator().create(std.meta.Child(@TypeOf(request.parent.value_0)));

    candidate.* = .{ .value = value, .history = history };

    try request.commit(.{ .store_0 = candidate, .store_1 = null });
}

pub fn right(request: *State.Request, value: u64, history: []const u64) !void {
    const candidate = try request.arena.allocator().create(std.meta.Child(@TypeOf(request.parent.value_1)));
    candidate.* = .{ .value = value, .history = history };

    try request.commit(.{ .store_0 = null, .store_1 = candidate });
}

pub fn values(request: *State.Request, count: usize, base: u64) ![]const u64 {
    const result = try request.arena.allocator().alloc(u64, count);

    for (result, 0..) |*item, index| item.* = base + @as(u64, @intCast(index));

    return result;
}
