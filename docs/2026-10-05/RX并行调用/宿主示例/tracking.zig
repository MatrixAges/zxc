const std = @import("std");
const Self = @This();

child: std.mem.Allocator,
threads: std.AutoHashMapUnmanaged(std.Thread.Id, void) = .empty,
mutex: std.Io.Mutex = .init,
pub fn allocator(self: *Self) std.mem.Allocator {
    return .{ .ptr = self, .vtable = &.{ .alloc = alloc, .resize = resize, .remap = remap, .free = free } };
}

fn alloc(context: *anyopaque, len: usize, alignment: std.mem.Alignment, ret_addr: usize) ?[*]u8 {
    const self: *Self = @ptrCast(@alignCast(context));

    std.Io.Threaded.mutexLock(&self.mutex);
    defer std.Io.Threaded.mutexUnlock(&self.mutex);
    self.threads.put(self.child, std.Thread.getCurrentId(), {}) catch return null;

    return self.child.rawAlloc(len, alignment, ret_addr);
}

fn resize(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) bool {
    const self: *Self = @ptrCast(@alignCast(context));

    return self.child.rawResize(memory, alignment, len, ret_addr);
}

fn remap(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) ?[*]u8 {
    const self: *Self = @ptrCast(@alignCast(context));

    return self.child.rawRemap(memory, alignment, len, ret_addr);
}

fn free(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, ret_addr: usize) void {
    const self: *Self = @ptrCast(@alignCast(context));

    self.child.rawFree(memory, alignment, ret_addr);
}
