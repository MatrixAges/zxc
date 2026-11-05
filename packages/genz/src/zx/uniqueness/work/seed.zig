const std = @import("std");
const ir = @import("zx").ir;
const Self = @This();

allocator: std.mem.Allocator,
queue: std.ArrayList(u64) = .empty,
head: usize = 0,
queued: []bool,
pub fn init(allocator: std.mem.Allocator, size: usize) std.mem.Allocator.Error!Self {
    return .{ .allocator = allocator, .queued = try allocator.alloc(bool, size) };
}

pub fn deinit(self: *Self) void {
    self.queue.deinit(self.allocator);
    self.allocator.free(self.queued);
}

pub fn fill(self: *Self, program: ir.Program) std.mem.Allocator.Error!void {
    self.queue.clearRetainingCapacity();

    self.head = 0;

    @memset(self.queued, false);

    for (program.functions.native_modules, 0..) |native, index| {
        if (native == null) try self.push(index);
    }

    if (!program.type_only) try self.push(program.functions.count());
}

pub fn push(self: *Self, index: usize) std.mem.Allocator.Error!void {
    if (self.queued[index]) return;

    self.queued[index] = true;

    try self.queue.append(self.allocator, index);
}

pub fn pop(self: *Self) std.mem.Allocator.Error!?usize {
    if (self.head == self.queue.items.len) return null;

    const index: usize = @intCast(self.queue.items[self.head]);

    self.head += 1;
    self.queued[index] = false;

    return index;
}

pub fn window(self: *const Self, size: usize) []const u64 {
    return self.queue.items[self.head..@min(self.queue.items.len, self.head + size)];
}
