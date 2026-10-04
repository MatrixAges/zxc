const std = @import("std");
const alpha = @import("alpha");
const beta = @import("beta");
const repeated = @import("repeat");
const Host = @import("store/host.zig");

test "unified Store public aliases observe shared updates and preserve old views" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var state: Host.State = &.{ .value = 3, .history = &.{8} };
    const original = state;
    var host = Host{ .store_0 = &state };

    try std.testing.expectEqual(@as(u64, 4), try alpha.execute(&arena, 1, &host));
    const previous = state;
    try std.testing.expectEqual(@as(u64, 4), try beta.execute(&arena, {}, &host));
    try std.testing.expectEqual(@as(u64, 6), try repeated.execute(&arena, 2, &host));
    try std.testing.expectEqual(@as(u64, 6), try beta.execute(&arena, {}, &host));
    try std.testing.expectEqual(@as(usize, 2), host.commits);
    try std.testing.expectEqualSlices(u64, &.{8}, original.history);
    try std.testing.expectEqualSlices(u64, &.{9}, previous.history);
    try std.testing.expectEqualSlices(u64, &.{10}, state.history);
}

test "unified Store readonly entry reads current host without reinitializing" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var state: Host.State = &.{ .value = 41, .history = &.{59} };
    var host = Host{ .store_0 = &state };

    try std.testing.expectEqual(@as(u64, 41), try beta.execute(&arena, {}, &host));
    state = &.{ .value = 101, .history = &.{59} };
    try std.testing.expectEqual(@as(u64, 101), try beta.execute(&arena, {}, &host));
    try std.testing.expectEqual(@as(usize, 0), host.attempts);
    try std.testing.expectEqualSlices(u64, &.{59}, state.history);
}

test "unified Store failed publication preserves state and allows later calls" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var state: Host.State = &.{ .value = 3, .history = &.{8} };
    var host = Host{ .store_0 = &state, .conflict_at = 1 };

    try std.testing.expectError(error.Conflict, alpha.execute(&arena, 7, &host));
    try std.testing.expectEqual(@as(u64, 3), try beta.execute(&arena, {}, &host));
    try std.testing.expectEqualSlices(u64, &.{8}, state.history);
    try std.testing.expectEqual(@as(u64, 5), try repeated.execute(&arena, 2, &host));
    host.conflict_at = 3;
    try std.testing.expectError(error.Conflict, alpha.execute(&arena, 11, &host));
    try std.testing.expectEqual(@as(u64, 5), try beta.execute(&arena, {}, &host));
    try std.testing.expectEqualSlices(u64, &.{9}, state.history);
    try std.testing.expectEqual(@as(usize, 1), host.commits);
}

test "unified Store independent hosts do not share application state" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    var left: Host.State = &.{ .value = 3, .history = &.{8} };
    var right: Host.State = &.{ .value = 100, .history = &.{200} };
    var a = Host{ .store_0 = &left };
    var b = Host{ .store_0 = &right };

    try std.testing.expectEqual(@as(u64, 7), try alpha.execute(&arena, 4, &a));
    try std.testing.expectEqual(@as(u64, 100), try beta.execute(&arena, {}, &b));
    try std.testing.expectEqual(@as(u64, 102), try repeated.execute(&arena, 2, &b));
    try std.testing.expectEqual(@as(u64, 7), try beta.execute(&arena, {}, &a));
    try std.testing.expectEqualSlices(u64, &.{9}, left.history);
    try std.testing.expectEqualSlices(u64, &.{201}, right.history);
}
