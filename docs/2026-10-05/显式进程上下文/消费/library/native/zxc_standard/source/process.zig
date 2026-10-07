const std = @import("std");

pub fn argv(allocator: std.mem.Allocator, process: std.process.Init.Minimal) ![]const []const u8 {
    var iterator = try process.args.iterateAllocator(allocator);

    defer iterator.deinit();

    var values: std.ArrayList([]const u8) = .empty;

    errdefer {
        for (values.items) |value| allocator.free(value);

        values.deinit(allocator);
    }

    while (iterator.next()) |value| {
        if (!std.unicode.utf8ValidateSlice(value)) return error.InvalidUtf8;

        const owned = try allocator.dupe(u8, value);

        errdefer allocator.free(owned);

        try values.append(allocator, owned);
    }

    return values.toOwnedSlice(allocator);
}

pub fn getEnv(allocator: std.mem.Allocator, process: std.process.Init.Minimal, key: []const u8) !?[]const u8 {
    if (key.len == 0 or std.mem.indexOfAny(u8, key, "\x00=") != null) return error.InvalidEnvironmentKey;
    if (!std.unicode.utf8ValidateSlice(key)) return error.InvalidUtf8;

    const value = process.environ.getAlloc(allocator, key) catch |err| switch (err) {
        error.EnvironmentVariableMissing => return null,
        else => return err,
    };

    errdefer allocator.free(value);

    if (!std.unicode.utf8ValidateSlice(value)) return error.InvalidUtf8;

    return value;
}

pub fn cwd(allocator: std.mem.Allocator, io: std.Io) ![]const u8 {
    var buffer: [std.fs.max_path_bytes]u8 = undefined;
    const length = try std.process.currentPath(io, &buffer);
    const value = buffer[0..length];

    if (!std.unicode.utf8ValidateSlice(value)) return error.InvalidUtf8;

    return allocator.dupe(u8, value);
}
