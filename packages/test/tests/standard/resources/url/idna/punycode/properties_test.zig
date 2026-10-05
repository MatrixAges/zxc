const std = @import("std");
const impl = @import("implementation");
const fixture = @import("fixture.zig");

test "Punycode matches independent codec on 256 mixed scalar sequences" {
    for (@import("mixed_cases.zig").cases, 0..) |entry, index| {
        errdefer std.debug.print("Punycode mixed sequence {d}\n", .{index});

        try fixture.checkEncode(std.testing.allocator, entry.points, entry.encoded);
        try fixture.checkDecode(std.testing.allocator, entry.encoded, entry.points);
    }
}

test "Punycode encoded digit case is ignored but ASCII prefix is preserved" {
    for (@import("rfc_cases.zig").cases) |entry| {
        const encoded = try std.testing.allocator.dupe(u8, entry.encoded);

        defer std.testing.allocator.free(encoded);

        const start = if (std.mem.lastIndexOfScalar(u8, encoded, '-')) |index| index + 1 else 0;

        for (encoded[start..]) |*byte| byte.* = std.ascii.toUpper(byte.*);
        try fixture.checkDecode(std.testing.allocator, encoded, entry.points);
    }
}

test "Punycode preserves every ASCII value including controls and delimiter" {
    var input: [128]u21 = undefined;
    var expected: [129]u8 = undefined;

    for (&input, expected[0..128], 0..) |*point, *byte, index| {
        point.* = @intCast(index);
        byte.* = @intCast(index);
    }

    expected[128] = '-';

    try fixture.checkEncode(std.testing.allocator, &input, &expected);
    try fixture.checkDecode(std.testing.allocator, &expected, &input);
}

test "Punycode does not perform Unicode normalization" {
    const composed = try impl.encode(std.testing.allocator, &.{0xe9});

    defer std.testing.allocator.free(composed);

    const decomposed = try impl.encode(std.testing.allocator, &.{ 0x65, 0x301 });

    defer std.testing.allocator.free(decomposed);

    try std.testing.expect(!std.mem.eql(u8, composed, decomposed));
    try fixture.checkDecode(std.testing.allocator, composed, &.{0xe9});
    try fixture.checkDecode(std.testing.allocator, decomposed, &.{ 0x65, 0x301 });
}
