const std = @import("std");
const splice = @import("splice_ranges");

test "runtime boundaries: all small splice ranges preserve results and inputs" {
    const original = [_]u64{ 10, 11, 12, 13, 14, 15, 16, 17 };
    const replacement = [_]u64{ 90, 91, 92 };

    for (0..original.len + 1) |length| {
        for (0..length + 1) |start| {
            for (0..length - start + 1) |count| {
                for (0..replacement.len + 1) |replacement_length| {
                    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

                    defer arena.deinit();

                    const result = try splice.execute(&arena, .{
                        .items = original[0..length],
                        .start = start,
                        .count = count,
                        .replacement = replacement[0..replacement_length],
                    });

                    var expected: std.ArrayList(u64) = .empty;

                    defer expected.deinit(std.testing.allocator);

                    for (0..length + 1) |position| {
                        if (position == start) {
                            for (replacement[0..replacement_length]) |value| {
                                try expected.append(std.testing.allocator, value);
                            }
                        }

                        if (position < length and (position < start or position >= start + count)) {
                            try expected.append(std.testing.allocator, original[position]);
                        }
                    }

                    try std.testing.expectEqualSlices(u64, expected.items, result.items);
                    try std.testing.expectEqualSlices(u64, original[start..][0..count], result.removed);
                    try std.testing.expectEqualSlices(u64, &.{ 10, 11, 12, 13, 14, 15, 16, 17 }, &original);
                    try std.testing.expectEqualSlices(u64, &.{ 90, 91, 92 }, &replacement);
                }
            }
        }
    }
}

test "runtime boundaries: splice invalid ranges fail before unsigned overflow" {
    const Case = struct { start: u64, count: u64 };

    for ([_]Case{
        .{ .start = 4, .count = 0 },
        .{ .start = 3, .count = 1 },
        .{ .start = 0, .count = std.math.maxInt(u64) },
        .{ .start = std.math.maxInt(u64), .count = 1 },
        .{ .start = 1, .count = std.math.maxInt(u64) },
    }) |case| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

        defer arena.deinit();

        try std.testing.expectError(error.IndexOutOfBounds, splice.execute(&arena, .{
            .items = &.{ 1, 2, 3 },
            .start = case.start,
            .count = case.count,
            .replacement = &.{},
        }));
    }
}

test "runtime evaluation: overwritten object expressions are still evaluated" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const program = @import("overwritten_evaluation");
    const result = try program.execute(&arena, .{ .items = &.{4}, .index = 0 });

    try std.testing.expectEqual(@as(u64, 9), result.value);
    try std.testing.expectError(error.IndexOutOfBounds, program.execute(&arena, .{ .items = &.{4}, .index = 1 }));
}

test "runtime ownership: deep clone detaches inner buffers before consuming" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    const first = [_]u64{ 1, 2 };
    const last = [_]u64{ 3, 4, 5 };
    const result = try @import("deep_clone").execute(&arena, &.{ &first, &last });

    try std.testing.expectEqualSlices(u64, &.{ 5, 4, 3 }, result.row);
    try std.testing.expectEqualSlices(u64, &first, result.rest[0]);
    try std.testing.expect(result.row.ptr != last[0..].ptr);
    try std.testing.expect(result.rest[0].ptr != first[0..].ptr);
    try std.testing.expectEqualSlices(u64, &.{ 1, 2 }, &first);
    try std.testing.expectEqualSlices(u64, &.{ 3, 4, 5 }, &last);

    const empty = try @import("deep_clone").execute(&arena, &.{});

    try std.testing.expectEqual(@as(usize, 0), empty.row.len);
    try std.testing.expectEqual(@as(usize, 0), empty.rest.len);
}
