const std = @import("std");
const impl = @import("implementation").url.host;

pub fn success(allocator: std.mem.Allocator, input: []const u8, is_opaque: bool, expected: []const u8) !void {
    const result = try impl.parse(allocator, input, is_opaque);

    defer allocator.free(result);

    try std.testing.expectEqualStrings(expected, result);
}

pub fn rejection(allocator: std.mem.Allocator, input: []const u8, is_opaque: bool, expected: anyerror) !void {
    const result = impl.parse(allocator, input, is_opaque) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(expected, err);

        return;
    };

    defer allocator.free(result);

    return error.TestExpectedError;
}
