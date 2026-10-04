const std = @import("std");
const original = @import("original");
const linked = @import("linked");

fn Host(comptime program: type) type {
    return struct {
        store_0: *const program.State,
        store_1: *const program.State,
        current: *program.State,
        conflict: bool = false,
        attempts: usize = 0,
        commits: usize = 0,

        pub fn commit(self: *@This(), pending: program.zx_pending) !void {
            self.attempts += 1;

            try std.testing.expect(pending.store_0 != null);
            try std.testing.expect(pending.store_1 == null);

            if (self.conflict) return error.Conflict;

            self.current.* = pending.store_0.?;
            self.commits += 1;
        }
    };
}

test "relinked Store and explicit input preserve staged reads and one commit" {
    inline for (.{ original, linked }) |program| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        var state: program.State = &.{ .count = 3 };
        const secondary: program.State = &.{ .count = 5 };
        const snapshot = state;
        var host = Host(program){ .store_0 = &state, .store_1 = &secondary, .current = &state };

        try std.testing.expectEqual(@as(u64, 10), try program.execute(&arena, 2, &host));
        try std.testing.expectEqual(@as(u64, 5), state.count);
        try std.testing.expectEqual(@as(u64, 3), snapshot.count);
        try std.testing.expectEqual(@as(u64, 5), secondary.count);
        try std.testing.expectEqual(@as(usize, 1), host.attempts);
        try std.testing.expectEqual(@as(usize, 1), host.commits);
    }
}

test "relinked commit conflict preserves host state and returns error" {
    inline for (.{ original, linked }) |program| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        var state: program.State = &.{ .count = 3 };
        const secondary: program.State = &.{ .count = 5 };
        var host = Host(program){ .store_0 = &state, .store_1 = &secondary, .current = &state, .conflict = true };

        try std.testing.expectError(error.Conflict, program.execute(&arena, 2, &host));
        try std.testing.expectEqual(@as(u64, 3), state.count);
        try std.testing.expectEqual(@as(u64, 5), secondary.count);
        try std.testing.expectEqual(@as(usize, 1), host.attempts);
        try std.testing.expectEqual(@as(usize, 0), host.commits);
    }
}

test "relinked repeated calls read latest committed state" {
    inline for (.{ original, linked }) |program| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        var state: program.State = &.{ .count = 3 };
        const secondary: program.State = &.{ .count = 5 };
        var host = Host(program){ .store_0 = &state, .store_1 = &secondary, .current = &state };

        try std.testing.expectEqual(@as(u64, 10), try program.execute(&arena, 2, &host));
        try std.testing.expectEqual(@as(u64, 12), try program.execute(&arena, 2, &host));
        try std.testing.expectEqual(@as(u64, 7), state.count);
        try std.testing.expectEqual(@as(usize, 2), host.commits);
    }
}
