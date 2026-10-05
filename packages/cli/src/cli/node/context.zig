const std = @import("std");
const api = @import("zxc_napi").api;
const stateful = @import("root").stateful;
const State = if (stateful) @import("zxc_state") else void;
const Task = @import("task.zig");
const Self = @This();

arena: std.heap.ArenaAllocator,
state: State = undefined,
env: api.Env,
references: usize = 1,
hooked: bool = false,
busy: bool = false,
running: bool = false,
closing: bool = false,
head: ?*Task = null,
tail: ?*Task = null,
pub fn retain(self: *Self) void {
    self.references += 1;
}

pub fn release(self: *Self) void {
    self.references -= 1;

    if (self.references != 0) return;
    if (self.hooked) _ = api.napi_remove_env_cleanup_hook(self.env, cleanup, self);
    if (stateful) self.state.deinit();

    self.arena.deinit();
    std.heap.page_allocator.destroy(self);
}

pub fn close(self: *Self) void {
    self.closing = true;

    while (self.head) |task| {
        self.head = task.next;

        task.destroy();
    }

    self.tail = null;
}

pub fn cleanup(data: ?*anyopaque) callconv(.c) void {
    const self: *Self = @ptrCast(@alignCast(data.?));

    self.hooked = false;

    self.retain();
    self.close();
    self.release();
}
