const std = @import("std");
const State = @import("zxc_state");

test "generated Request fails Region registration before publishing either Object" {
    var failing = std.testing.FailingAllocator.init(std.testing.allocator, .{});
    var arena = std.heap.ArenaAllocator.init(failing.allocator());

    defer arena.deinit();

    var state = State{ .arena = &arena };

    defer state.deinit();

    try state.initialize();

    failing.fail_index = failing.alloc_index;
    failing.resize_fail_index = failing.resize_index;

    var observed_failure = false;
    const bound = arena.queryCapacity() + 1;

    for (0..bound) |_| {
        var request = state.request();

        request.arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer request.deinit();

        const left = state.value_0;
        const right = state.value_1;

        if (request.execute(1)) |_| {
            try std.testing.expectEqual(left.value + 1, state.value_0.value);
            try std.testing.expectEqual(right.value + 1, state.value_1.value);
        } else |err| {
            try std.testing.expectEqual(error.OutOfMemory, err);
            try std.testing.expect(failing.has_induced_failure);
            try std.testing.expectEqual(left, state.value_0);
            try std.testing.expectEqual(right, state.value_1);

            observed_failure = true;

            break;
        }
    }

    try std.testing.expect(observed_failure);

    failing.fail_index = std.math.maxInt(usize);
    failing.resize_fail_index = std.math.maxInt(usize);
    const left = state.value_0;
    const right = state.value_1;

    {
        var recovery = state.request();

        defer recovery.deinit();

        _ = try recovery.execute(2);
    }

    try std.testing.expectEqual(left.value + 2, state.value_0.value);
    try std.testing.expectEqual(right.value + 2, state.value_1.value);
}
