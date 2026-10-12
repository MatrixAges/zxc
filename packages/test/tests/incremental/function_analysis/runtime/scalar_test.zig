const std = @import("std");
const program = @import("program");
const last = @import("last");
const count: u64 = @import("options").count;

test "split scalar entry executes zero and ordinary inputs" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    for ([_]u64{ 0, 7, 127, 65535 }) |input| try std.testing.expectEqual(input + count, try program.execute(&arena, input));
}

test "split scalar entry reaches the unsigned upper boundary exactly" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(std.math.maxInt(u64), try program.execute(&arena, std.math.maxInt(u64) - count));
}

test "split scalar entry preserves earlier results across later calls" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = try program.execute(&arena, 3);

    try std.testing.expectEqual(1000 + count, try program.execute(&arena, 1000));
    try std.testing.expectEqual(3 + count, first);
}

test "split scalar entry executes with its first allocation forbidden" {
    var tracked = std.testing.FailingAllocator.init(std.testing.allocator, .{ .fail_index = 0 });
    var arena = std.heap.ArenaAllocator.init(tracked.allocator());

    defer arena.deinit();

    try std.testing.expectEqual(23 + count, try program.execute(&arena, 23));
    try std.testing.expectEqual(@as(usize, 0), tracked.allocated_bytes);
    try std.testing.expect(!tracked.has_induced_failure);
}

test "split scalar last function agrees with the ordinary entry" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    for ([_]u64{ 0, 17, 1025 }) |input| {
        const direct = try last.call(std.testing.allocator, input);

        try std.testing.expectEqual(input + count, direct);
        try std.testing.expectEqual(direct, try program.execute(&arena, input));
    }
}
