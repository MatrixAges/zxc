const std = @import("std");
const program = @import("program");

const Host = struct {
    store_0: *const program.State,
    store_1: *program.State,
    commits: usize = 0,
    conflict_at: usize,
    pub fn commit(self: *Host, pending: program.zx_pending) !void {
        if (self.commits + 1 == self.conflict_at) return error.Conflict;
        if (pending.store_0 != null) return error.UnexpectedSpareWrite;
        if (pending.store_1) |next| self.store_1.* = next;

        self.commits += 1;
    }
};

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var state: program.State = &.{ .count = 3, .items = &.{8} };
    const spare: program.State = &.{ .count = 99, .items = &.{} };
    var host = Host{ .store_0 = &spare, .store_1 = &state, .conflict_at = try std.fmt.parseInt(usize, args[1], 10) };

    const output = program.execute(init.arena, &.{ .increment = 1, .index = 0 }, &host) catch |err| {
        std.debug.print("error={s} count={d} commits={d} spare={d}\n", .{ @errorName(err), state.count, host.commits, spare.count });

        return;
    };

    std.debug.print("output={d} count={d} commits={d} spare={d}\n", .{ output, state.count, host.commits, spare.count });
}
