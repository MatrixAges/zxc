const std = @import("std");
const initial = @import("counter_initial");
const settings_initial = @import("settings_initial");
const advance = @import("advance");
const again = @import("again");
const read = @import("read");
const settings = @import("settings");
const State = initial.Output;

const Host = struct {
    store_0: *State,
    commits: usize = 0,
    reject: bool = false,
    pub fn commit(self: *@This(), pending: anytype) !void {
        if (self.reject) return error.Conflict;

        self.store_0.* = pending.store_0 orelse return error.EmptyCommit;
        self.commits += 1;
    }
};

test "published aliases use generated initial state and preserve old snapshots" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = try initial.execute(&arena, {});
    const original = state;
    var host = Host{ .store_0 = &state };

    try std.testing.expectEqual(@as(u64, 4), try advance.execute(&arena, 1, &host));

    const previous = state;

    try std.testing.expectEqual(@as(u64, 6), try again.execute(&arena, 2, &host));
    try std.testing.expectEqual(@as(u64, 6), try read.execute(&arena, {}, &host));
    try std.testing.expectEqualSlices(u64, &.{8}, original.history);
    try std.testing.expectEqualSlices(u64, &.{9}, previous.history);
    try std.testing.expectEqualSlices(u64, &.{10}, state.history);
    try std.testing.expectEqual(@as(usize, 2), host.commits);

    const fresh = try initial.execute(&arena, {});

    try std.testing.expectEqual(@as(u64, 3), fresh.value);
    try std.testing.expectEqualSlices(u64, &.{8}, fresh.history);
}

test "failed commit retains generated state and later commit succeeds" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = try initial.execute(&arena, {});
    const original = state;
    var host = Host{ .store_0 = &state, .reject = true };

    try std.testing.expectError(error.Conflict, advance.execute(&arena, 9, &host));
    try std.testing.expect(state == original);

    host.reject = false;

    try std.testing.expectEqual(@as(u64, 5), try again.execute(&arena, 2, &host));
    try std.testing.expectEqual(@as(usize, 1), host.commits);
    try std.testing.expectEqualSlices(u64, &.{8}, original.history);
}

test "settings public reader accepts the shared generated initialization ABI" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var state = try settings_initial.execute(&arena, {});
    var host = .{ .store_0 = &state };
    const result = try settings.execute(&arena, {}, &host);

    try std.testing.expectEqualStrings("fresh", result.label);
    try std.testing.expectEqual(@as(?u64, 17), result.maybe);
    try std.testing.expectEqualSlices(u64, &.{ 2, 3 }, result.matrix[1]);
}
