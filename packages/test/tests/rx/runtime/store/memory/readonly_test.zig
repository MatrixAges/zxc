const std = @import("std");
const application = @import("application");
const State = @import("zxc_state");
const Scenario = enum { readonly, multiple, execution };

fn check(allocator: std.mem.Allocator, scenario: Scenario) !void {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    var state = State{ .arena = &arena };

    try state.initialize();

    const original_left = state.value_0;
    const original_right = state.value_1;
    var candidate = original_left.*;

    candidate.value = 99;

    switch (scenario) {
        .readonly => try std.testing.expectError(error.StoreNotWritable, state.commit(.{ .store_0 = &candidate, .store_1 = null })),
        .multiple => {
            var right = original_right.*;

            right.value = 77;
            try std.testing.expectError(error.MultipleStoreObjects, state.commit(.{ .store_0 = &candidate, .store_1 = &right }));
        },
        .execution => {
            const result = try application.execute(&arena, 7, &state);

            try std.testing.expectEqual(@as(u64, 3), result.before.first);
            try std.testing.expectEqual(@as(u64, 10), result.written);
            try std.testing.expectEqual(@as(u64, 17), result.overlap);
            try std.testing.expectEqual(@as(u64, 14), state.value_1.value);
        },
    }

    try std.testing.expectEqual(original_left, state.value_0);
    if (scenario != .execution) try std.testing.expectEqual(original_right, state.value_1);
    try std.testing.expectEqual(@as(u64, 3), original_left.value);
    try std.testing.expectEqual(@as(u64, 100), original_right.value);
}

test "generated State rejects read only Object publication" {
    try check(std.testing.allocator, .readonly);
}

test "generated State multiple Object guard preserves read only and writable values" {
    try check(std.testing.allocator, .multiple);
}

test "generated State writable peer remains usable with a read only Object" {
    try check(std.testing.allocator, .execution);
}
