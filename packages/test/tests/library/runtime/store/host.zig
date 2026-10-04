const std = @import("std");
const alpha = @import("alpha");
const Self = @This();
pub const State = std.meta.Child(@FieldType(alpha.zx_pending, "store_0"));

store_0: *State,
attempts: usize = 0,
commits: usize = 0,
conflict_at: ?usize = null,

pub fn commit(self: *Self, pending: anytype) !void {
    const next = pending.store_0 orelse return error.UnexpectedEmptyCommit;
    self.attempts += 1;
    if (self.conflict_at == self.attempts) return error.Conflict;

    self.store_0.* = next;
    self.commits += 1;
}
