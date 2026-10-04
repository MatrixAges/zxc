const program = @import("program");
const left = @import("left");
const right = @import("right");
const Self = @This();

store_0: *left.Output,
store_1: *right.Output,
commits: usize = 0,
conflict_at: ?usize = null,
pub fn commit(self: *Self, pending: program.zx_pending) !void {
    if ((pending.store_0 == null) == (pending.store_1 == null)) return error.InvalidPendingSlots;
    if (self.conflict_at == self.commits + 1) return error.Conflict;
    if (pending.store_0) |next| self.store_0.* = next;
    if (pending.store_1) |next| self.store_1.* = next;

    self.commits += 1;
}
