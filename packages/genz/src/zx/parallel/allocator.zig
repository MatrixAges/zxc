pub const source =
    \\const zx_parallel_allocator = struct {
    \\    child: std.mem.Allocator,
    \\    mutex: std.Io.Mutex = .init,
    \\
    \\    fn allocator(self: *@This()) std.mem.Allocator {
    \\        return .{ .ptr = self, .vtable = &.{ .alloc = alloc, .resize = resize, .remap = remap, .free = free } };
    \\    }
    \\
    \\    fn alloc(context: *anyopaque, len: usize, alignment: std.mem.Alignment, ret_addr: usize) ?[*]u8 {
    \\        const self: *@This() = @ptrCast(@alignCast(context));
    \\
    \\        std.Io.Threaded.mutexLockUncancelable(&self.mutex);
    \\        defer std.Io.Threaded.mutexUnlock(&self.mutex);
    \\
    \\        return self.child.rawAlloc(len, alignment, ret_addr);
    \\    }
    \\
    \\    fn resize(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) bool {
    \\        const self: *@This() = @ptrCast(@alignCast(context));
    \\
    \\        std.Io.Threaded.mutexLockUncancelable(&self.mutex);
    \\        defer std.Io.Threaded.mutexUnlock(&self.mutex);
    \\
    \\        return self.child.rawResize(memory, alignment, len, ret_addr);
    \\    }
    \\
    \\    fn remap(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, len: usize, ret_addr: usize) ?[*]u8 {
    \\        const self: *@This() = @ptrCast(@alignCast(context));
    \\
    \\        std.Io.Threaded.mutexLockUncancelable(&self.mutex);
    \\        defer std.Io.Threaded.mutexUnlock(&self.mutex);
    \\
    \\        return self.child.rawRemap(memory, alignment, len, ret_addr);
    \\    }
    \\
    \\    fn free(context: *anyopaque, memory: []u8, alignment: std.mem.Alignment, ret_addr: usize) void {
    \\        const self: *@This() = @ptrCast(@alignCast(context));
    \\
    \\        std.Io.Threaded.mutexLockUncancelable(&self.mutex);
    \\        defer std.Io.Threaded.mutexUnlock(&self.mutex);
    \\
    \\        self.child.rawFree(memory, alignment, ret_addr);
    \\    }
    \\};
    \\
;
