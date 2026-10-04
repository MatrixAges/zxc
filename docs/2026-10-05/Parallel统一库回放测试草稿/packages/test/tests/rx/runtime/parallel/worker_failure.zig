const std = @import("std");
const Self = @This();

child: std.mem.Allocator,
parent: std.Thread.Id,
failed: std.atomic.Value(bool) = .init(false),
pub fn allocator(self: *Self) std.mem.Allocator {
    return .{ .ptr = self, .vtable = &.{ .alloc = alloc, .resize = resize, .remap = remap, .free = free } };
}

fn rejects(self: *Self) bool {
    if (std.Thread.getCurrentId() == self.parent) return false;

    self.failed.store(true, .monotonic);

    return true;
}

fn alloc(context: *anyopaque, len: usize, alignment: std.mem.Alignment, ret_addr: usize) ?[*]u8 {
    const self: *Self = @ptrCast(@alignCast(context));

    if (self.rejects()) return null;

    return self.child.rawAlloc(len, alignment, ret_addr);
}

fn resize(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) bool {
    const self: *Self = @ptrCast(@alignCast(context));

    if (self.rejects()) return false;

    return self.child.rawResize(memory, alignment, len, ret_addr);
}

fn remap(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) ?[*]u8 {
    const self: *Self = @ptrCast(@alignCast(context));

    if (self.rejects()) return null;

    return self.child.rawRemap(memory, alignment, len, ret_addr);
}

fn free(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, ret_addr: usize) void {
    const self: *Self = @ptrCast(@alignCast(context));

    self.child.rawFree(memory, alignment, ret_addr);
}
