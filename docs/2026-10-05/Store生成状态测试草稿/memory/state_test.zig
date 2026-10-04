const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");
const Scenario = enum { continuity, isolation, multiple, empty };

fn check(allocator: std.mem.Allocator, scenario: Scenario) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    try state.initialize();

    const original_left = state.value_0;
    const original_right = state.value_1;

    try std.testing.expectEqual(&state.value_0, state.store_0);
    try std.testing.expectEqual(&state.value_1, state.store_1);

    switch (scenario) {
        .continuity => {
            const first = try application.execute(&arena, 1, &state);
            const second = try application.execute(&arena, 7, &state);

            try std.testing.expectEqual(@as(u64, 4), first.after_left.value);
            try std.testing.expectEqual(@as(u64, 101), first.after_right.value);
            try std.testing.expectEqual(@as(u64, 4), second.before_left.value);
            try std.testing.expectEqual(@as(u64, 101), second.before_right.value);
            try std.testing.expectEqual(@as(u64, 11), second.after_left.value);
            try std.testing.expectEqual(@as(u64, 108), second.after_right.value);
            try std.testing.expectEqualSlices(u64, &.{9}, first.after_left.history);
            try std.testing.expectEqualSlices(u64, &.{10}, second.after_left.history);
            try std.testing.expectEqualSlices(u64, &.{51}, first.after_right.history);
            try std.testing.expectEqualSlices(u64, &.{52}, second.after_right.history);
        },
        .isolation => {
            var other_arena = std.heap.ArenaAllocator.init(allocator);

            defer other_arena.deinit();

            var other = State{ .arena = &other_arena };

            try other.initialize();
            _ = try application.execute(&arena, 7, &state);
            const result = try application.execute(&other_arena, 1, &other);

            try std.testing.expectEqual(@as(u64, 3), result.before_left.value);
            try std.testing.expectEqual(@as(u64, 100), result.before_right.value);
            try std.testing.expectEqual(@as(u64, 10), state.value_0.value);
            try std.testing.expectEqual(@as(u64, 4), other.value_0.value);
            try std.testing.expectEqual(@as(u64, 107), state.value_1.value);
            try std.testing.expectEqual(@as(u64, 101), other.value_1.value);
        },
        .multiple => {
            var candidate_left = state.value_0.*;
            var candidate_right = state.value_1.*;

            candidate_left.value = 77;
            candidate_right.value = 88;
            try std.testing.expectError(error.MultipleStoreObjects, state.commit(.{ .store_0 = &candidate_left, .store_1 = &candidate_right }));
            try std.testing.expectEqual(original_left, state.value_0);
            try std.testing.expectEqual(original_right, state.value_1);
            const result = try application.execute(&arena, 1, &state);

            try std.testing.expectEqual(@as(u64, 4), result.first);
            try std.testing.expectEqual(@as(u64, 101), result.second);
        },
        .empty => {
            try state.commit(.{ .store_0 = null, .store_1 = null });
            try std.testing.expectEqual(original_left, state.value_0);
            try std.testing.expectEqual(original_right, state.value_1);
        },
    }

    try std.testing.expectEqual(@as(u64, 3), original_left.value);
    try std.testing.expectEqual(@as(u64, 100), original_right.value);
    try std.testing.expectEqualSlices(u64, &.{8}, original_left.history);
    try std.testing.expectEqualSlices(u64, &.{50}, original_right.history);
    try std.testing.expectEqual(&state.value_0, state.store_0);
    try std.testing.expectEqual(&state.value_1, state.store_1);
}

test "generated State continues across top level calls and retains old borrows" {
    try check(std.testing.allocator, .continuity);
}

test "generated State isolates two live application instances" {
    try check(std.testing.allocator, .isolation);
}

test "generated State rejects multiple Object publication before any write" {
    try check(std.testing.allocator, .multiple);
}

test "generated State accepts an empty pending update without replacing values" {
    try check(std.testing.allocator, .empty);
}

test "generated State initialization and repeated calls release failed allocations" {
    try std.testing.checkAllAllocationFailures(std.testing.allocator, check, .{Scenario.continuity});
}
