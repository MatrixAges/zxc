const std = @import("std");
const fixture = @import("fixture.zig");

fn forbiddenHost(byte: u8) bool {
    return switch (byte) {
        0, 9, 10, 13, 32, 35, 47, 58, 60, 62, 63, 64, 91, 92, 93, 94, 124 => true,
        else => false,
    };
}

test "host special ASCII matrix follows forbidden domain code points" {
    for (0..128) |value| {
        const byte: u8 = @intCast(value);
        const input = [_]u8{ 'A', byte, 'b' };

        if (forbiddenHost(byte) or byte < 32 or byte == 37 or byte == 127) {
            try fixture.rejection(std.testing.allocator, &input, false, error.InvalidHost);
        } else {
            const expected = [_]u8{ 'a', std.ascii.toLower(byte), 'b' };

            try fixture.success(std.testing.allocator, &input, false, &expected);
        }
    }
}

test "host opaque ASCII matrix preserves printable values and escapes other controls" {
    for (0..128) |value| {
        const byte: u8 = @intCast(value);
        const input = [_]u8{ 'A', byte, 'b' };

        if (forbiddenHost(byte)) {
            try fixture.rejection(std.testing.allocator, &input, true, error.InvalidHost);
        } else if (byte < 32 or byte == 127) {
            const expected = try std.fmt.allocPrint(std.testing.allocator, "A%{X:0>2}b", .{byte});

            defer std.testing.allocator.free(expected);

            try fixture.success(std.testing.allocator, &input, true, expected);
        } else try fixture.success(std.testing.allocator, &input, true, &input);
    }
}

test "host single percent encoded byte matrix differs by mode" {
    for (0..256) |value| {
        const byte: u8 = @intCast(value);
        const input = try std.fmt.allocPrint(std.testing.allocator, "A%{X:0>2}b", .{byte});

        defer std.testing.allocator.free(input);

        try fixture.success(std.testing.allocator, input, true, input);

        if (byte >= 128) {
            try fixture.rejection(std.testing.allocator, input, false, error.InvalidDomain);
        } else if (forbiddenHost(byte) or byte < 32 or byte == 37 or byte == 127) {
            try fixture.rejection(std.testing.allocator, input, false, error.InvalidHost);
        } else {
            const expected = [_]u8{ 'a', std.ascii.toLower(byte), 'b' };

            try fixture.success(std.testing.allocator, input, false, &expected);
        }
    }
}

test "host rejects every isolated high byte as malformed UTF8" {
    for (128..256) |value| {
        const input = [_]u8{ 'a', @intCast(value), 'b' };

        try fixture.rejection(std.testing.allocator, &input, false, error.InvalidDomain);
        try fixture.rejection(std.testing.allocator, &input, true, error.InvalidHost);
    }
}
