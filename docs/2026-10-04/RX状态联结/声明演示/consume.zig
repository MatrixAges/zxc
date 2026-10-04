const std = @import("std");
const program = @import("program");
const initial = @import("initial");
const State = initial.Output;

const Host = struct {
    store_0: *State,
    commits: usize = 0,
    conflict_at: usize,
    pub fn commit(self: *Host, pending: program.zx_pending) !void {
        if (self.commits + 1 == self.conflict_at) return error.Conflict;
        if (pending.store_0) |next| self.store_0.* = next;

        self.commits += 1;
    }
};

pub fn main(init: std.process.Init) !void {
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    var state = try initial.execute(init.arena, {});
    var host = Host{ .store_0 = &state, .conflict_at = try std.fmt.parseInt(usize, args[1], 10) };

    const output = program.execute(init.arena, try std.fmt.parseInt(u64, args[2], 10), &host) catch |err| {
        std.debug.print("error={s} state={d} commits={d}\n", .{ @errorName(err), state.value, host.commits });

        return;
    };

    std.debug.print("first={d} second={d} current={d} state={d} commits={d}\n", .{ output.first, output.second, output.current, state.value, host.commits });
}
