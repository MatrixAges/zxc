const std = @import("std");
const program = @import("program");
const owned = @import("options").owned;
const mutating = @import("options").mutating;

pub fn run(allocator: std.mem.Allocator, count: usize) !void {
    const original = try std.testing.allocator.alloc(u64, count);

    defer std.testing.allocator.free(original);

    for (original, 0..) |*value, index| value.* = if (index % 11 == 0) std.math.maxInt(u64) else @intCast(index % 17);

    const expected = try std.testing.allocator.alloc(u64, count + if (mutating) @as(usize, 0) else if (owned) @as(usize, 1) else 2);

    defer std.testing.allocator.free(expected);

    if (mutating) {
        for (original, 0..) |value, index| expected[expected.len - 1 - index] = value;
    } else if (owned) {
        @memcpy(expected[0..count], original);

        expected[count] = @intCast(count);
    } else {
        expected[0] = @intCast(count + 1);
        expected[1] = @intCast(count);

        for (original, 0..) |value, index| expected[expected.len - 1 - index] = value;
    }

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const input = try arena.allocator().dupe(u64, original);
    const actual = program.execute(&arena, input);

    if (!owned) try std.testing.expectEqualSlices(u64, original, input);

    try std.testing.expectEqualSlices(u64, expected, try actual);
}
