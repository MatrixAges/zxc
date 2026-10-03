const std = @import("std");
const builtin = @import("builtin");

pub fn root(allocator: std.mem.Allocator, environment: *const std.process.Environ.Map) ![]const u8 {
    if (environment.get("ZXC_CACHE_DIR")) |path| {
        if (!std.fs.path.isAbsolute(path)) return error.InvalidZxcCacheDirectory;

        return path;
    }

    const base = switch (builtin.os.tag) {
        .windows => environment.get("LOCALAPPDATA") orelse return error.MissingUserCacheDirectory,
        .macos => environment.get("HOME") orelse return error.MissingUserCacheDirectory,
        else => environment.get("XDG_CACHE_HOME") orelse environment.get("HOME") orelse return error.MissingUserCacheDirectory,
    };

    if (!std.fs.path.isAbsolute(base)) return error.InvalidUserCacheDirectory;

    return switch (builtin.os.tag) {
        .windows => std.fs.path.join(allocator, &.{ base, "zxc", "cache" }),
        .macos => std.fs.path.join(allocator, &.{ base, "Library", "Caches", "zxc" }),
        else => std.fs.path.join(allocator, if (environment.get("XDG_CACHE_HOME") != null) &.{ base, "zxc" } else &.{ base, ".cache", "zxc" }),
    };
}
