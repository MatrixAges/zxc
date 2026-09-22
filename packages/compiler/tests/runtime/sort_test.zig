const std = @import("std");
const runtime = @import("runtime");

test "sort: preserves every element across lengths and input orders" {
    var random = std.Random.DefaultPrng.init(0x7a7863);
    var storage: [513]u64 = undefined;
    var expected: [513]u64 = undefined;

    for (0..storage.len + 1) |length| {
        for (0..4) |order| {
            for (storage[0..length], 0..) |*value, index| {
                value.* = switch (order) {
                    0 => index,
                    1 => length - index,
                    2 => 7,
                    else => random.random().int(u64) % 97,
                };
            }

            @memcpy(expected[0..length], storage[0..length]);
            std.sort.insertion(u64, expected[0..length], {}, std.sort.asc(u64));

            const sorted = runtime.sort(u64, storage[0..length]);

            try std.testing.expect(sorted[0].ptr == storage[0..length].ptr);
            try std.testing.expectEqualSlices(u64, expected[0..length], sorted[0]);
        }
    }
}

test "sort: signed numbers strings and floating point exceptional values" {
    var integers = [_]i64{ 0, std.math.maxInt(i64), -1, std.math.minInt(i64) };
    const signed = runtime.sort(i64, &integers);

    try std.testing.expectEqualSlices(i64, &.{ std.math.minInt(i64), -1, 0, std.math.maxInt(i64) }, signed[0]);

    var strings = [_][]const u8{ "zx", "", "zig", "a", "zig" };
    const words = runtime.sort([]const u8, &strings);

    for (words[0], [_][]const u8{ "", "a", "zig", "zig", "zx" }) |actual, expected| {
        try std.testing.expectEqualStrings(expected, actual);
    }

    var floats = [_]f64{ std.math.nan(f64), 0.0, std.math.inf(f64), -2.0, -std.math.inf(f64), -0.0, std.math.nan(f64) };
    const numbers = runtime.sort(f64, &floats);

    try std.testing.expectEqualSlices(f64, &.{ -std.math.inf(f64), -2.0, 0.0, 0.0, std.math.inf(f64) }, numbers[0][0..5]);
    try std.testing.expect(std.math.isNan(numbers[0][5]));
    try std.testing.expect(std.math.isNan(numbers[0][6]));
    try std.testing.expect(std.math.signbit(numbers[0][2]) != std.math.signbit(numbers[0][3]));
}
