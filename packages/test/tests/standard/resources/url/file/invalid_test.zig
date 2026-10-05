const std = @import("std");
const url = @import("implementation").url;

test "file path conversion rejects malformed UTF-8 on both platforms" {
    for ([_][]const u8{ "\xff", "\xc0\xaf", "\xed\xa0\x80", "\xf4\x90\x80\x80", "\xe4\xbd" }) |suffix| {
        for ([_]bool{ false, true }) |windows| {
            const input = try std.mem.concat(std.testing.allocator, u8, &.{ if (windows) "C:\\a" else "/a", suffix });

            defer std.testing.allocator.free(input);

            try std.testing.expectError(error.InvalidFilePath, url.pathToFileUrl(std.testing.allocator, input, windows, if (windows) "C:\\" else "/"));
        }
    }
}

test "file path conversion rejects missing host in raw URL records" {
    const value = url.Url{ .scheme = "file", .path = &.{ "C:", "a" } };

    for ([_]bool{ false, true }) |windows| {
        try std.testing.expectError(error.InvalidFileUrl, url.fileUrlToPath(std.testing.allocator, value, windows));
        try std.testing.expectError(error.InvalidFileUrl, url.fileUrlToBytes(std.testing.allocator, value, windows));
    }
}
