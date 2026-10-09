const std = @import("std");
const Self = @This();

child: std.mem.Allocator,
threads: [16]std.Thread.Id = undefined,
count: usize = 0,
mutex: std.Io.Mutex = .init,
pub fn allocator(self: *Self) std.mem.Allocator {
    return .{ .ptr = self, .vtable = &.{ .alloc = alloc, .resize = resize, .remap = remap, .free = free } };
}

fn record(self: *Self) void {
    std.Io.Threaded.mutexLockUncancelable(&self.mutex);
    defer std.Io.Threaded.mutexUnlock(&self.mutex);

    const id = std.Thread.getCurrentId();

    for (self.threads[0..self.count]) |seen| {
        if (seen == id) return;
    }

    std.debug.assert(self.count < self.threads.len);

    self.threads[self.count] = id;
    self.count += 1;
}

pub fn workers(self: *const Self) usize {
    var count: usize = 0;

    for (self.threads[0..self.count]) |id| {
        if (id != std.Thread.getCurrentId()) count += 1;
    }

    return count;
}

fn alloc(context: *anyopaque, len: usize, alignment: std.mem.Alignment, ret_addr: usize) ?[*]u8 {
    const self: *Self = @ptrCast(@alignCast(context));

    self.record();

    return self.child.rawAlloc(len, alignment, ret_addr);
}

fn resize(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) bool {
    const self: *Self = @ptrCast(@alignCast(context));

    self.record();

    return self.child.rawResize(memory, alignment, len, ret_addr);
}

fn remap(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) ?[*]u8 {
    const self: *Self = @ptrCast(@alignCast(context));

    self.record();

    return self.child.rawRemap(memory, alignment, len, ret_addr);
}

fn free(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, ret_addr: usize) void {
    const self: *Self = @ptrCast(@alignCast(context));

    self.child.rawFree(memory, alignment, ret_addr);
}
