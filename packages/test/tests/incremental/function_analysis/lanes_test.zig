const std = @import("std");
const f = @import("lane_fixture.zig");

test "owned lane copy preserves an empty outer table" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    try std.testing.expectEqual(@as(usize, 0), (try f.checks.lanes.copy(arena.allocator(), &.{})).len);
}

test "owned lane copy isolates input output mutation and call slices" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var source: f.Source = .{};
    var expected: f.Source = .{};
    const saved = try f.checks.lanes.copy(arena.allocator(), &.{&.{source.lane()}});

    source.poisonFlat();

    try std.testing.expectEqualDeep(expected.lane(), saved[0][0]);
}

test "owned lane copy isolates iteration descriptors and nested paths" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var source: f.Source = .{};
    var expected: f.Source = .{};
    const saved = try f.checks.lanes.copy(arena.allocator(), &.{&.{source.lane()}});

    source.poisonIterations();

    try std.testing.expectEqualDeep(expected.lane(), saved[0][0]);
}

test "owned lane copy survives release of its source arena" {
    var owned = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer owned.deinit();

    const saved = block: {
        var temporary = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer temporary.deinit();

        const source = try temporary.allocator().create(f.Source);
        source.* = .{};

        const lanes = try temporary.allocator().dupe(f.Lane, &.{source.lane()});
        const groups = try temporary.allocator().dupe([]const f.Lane, &.{ &.{}, lanes, lanes });

        break :block try f.checks.lanes.copy(owned.allocator(), groups);
    };

    var expected: f.Source = .{};

    try std.testing.expectEqual(@as(usize, 3), saved.len);
    try std.testing.expectEqual(@as(usize, 0), saved[0].len);
    try std.testing.expectEqualDeep(expected.lane(), saved[1][0]);
    try std.testing.expectEqualDeep(expected.lane(), saved[2][0]);
}
