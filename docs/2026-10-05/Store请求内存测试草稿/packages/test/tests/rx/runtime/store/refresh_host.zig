const std = @import("std");
const program = @import("program");
const initial = @import("initial");
const Self = @This();

store_0: *initial.Output,
arena: *std.heap.ArenaAllocator,
snapshots: [3]u64,
begins: usize = 0,
commits: usize = 0,
fail_at: ?usize = null,
pub fn begin(self: *Self, comptime slots: anytype) !void {
    try std.testing.expectEqualSlices(u32, &.{0}, &slots);

    self.begins += 1;

    if (self.fail_at == self.begins) return error.RefreshFailed;
    if (self.begins > self.snapshots.len) return error.UnexpectedRefresh;

    const next = try self.arena.allocator().create(std.meta.Child(initial.Output));

    next.* = self.store_0.*.*;
    next.value = self.snapshots[self.begins - 1];
    self.store_0.* = next;
}

pub fn commit(self: *Self, pending: program.zx_pending) !void {
    self.store_0.* = pending.store_0 orelse return error.UnexpectedEmptyCommit;
    self.commits += 1;
}
