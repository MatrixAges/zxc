const std = @import("std");
const program = @import("program");
const left = @import("left");
const right = @import("right");
const Self = @This();

store_0: *left.Output,
store_1: *right.Output,
arena: *std.heap.ArenaAllocator,
begins: usize = 0,
commits: usize = 0,
fail_at: ?usize = null,

pub fn begin(self: *Self, comptime slots: anytype) !void {
    const order = [_]u32{ 0, 1, 0, 1, 1, 0, 1 };

    if (self.begins >= order.len) return error.UnexpectedRefresh;
    try std.testing.expectEqualSlices(u32, order[self.begins..][0..1], &slots);
    self.begins += 1;

    if (self.fail_at == self.begins) return error.RefreshFailed;

    inline for (slots) |slot| {
        const target = if (slot == 0) self.store_0 else self.store_1;
        const next = try self.arena.allocator().create(std.meta.Child(@TypeOf(target.*)));

        next.* = target.*.*;
        next.value += 100;
        target.* = next;
    }
}

pub fn commit(self: *Self, pending: program.zx_pending) !void {
    if ((pending.store_0 == null) == (pending.store_1 == null)) return error.InvalidPendingSlots;

    if (pending.store_0) |next| self.store_0.* = next;
    if (pending.store_1) |next| self.store_1.* = next;

    self.commits += 1;
}
