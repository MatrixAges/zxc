const program = @import("program");
const initial = @import("initial");
const Self = @This();

store_0: *initial.Output,
commits: usize = 0,
conflict_at: ?usize = null,

pub fn commit(self: *Self, pending: program.zx_pending) !void {
    const next = pending.store_0 orelse return error.UnexpectedEmptyCommit;

    if (self.conflict_at == self.commits + 1) return error.Conflict;

    self.store_0.* = next;
    self.commits += 1;
}
