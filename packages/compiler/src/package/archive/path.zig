const std = @import("std");

pub fn normalize(name: []const u8, directory: bool) ![]const u8 {
    var path = name;

    if (std.mem.startsWith(u8, path, "/")) return error.InvalidPackageArchivePath;

    while (std.mem.startsWith(u8, path, "./")) path = path[2..];
    if (directory) path = std.mem.trimEnd(u8, path, "/");
    if (directory and (path.len == 0 or std.mem.eql(u8, path, "."))) return "";
    if (path.len == 0 or std.mem.indexOfAny(u8, path, "\\:\x00\r\n") != null) return error.InvalidPackageArchivePath;

    var parts = std.mem.splitScalar(u8, path, '/');

    while (parts.next()) |part| {
        if (part.len == 0 or std.mem.eql(u8, part, ".") or std.mem.eql(u8, part, "..")) return error.InvalidPackageArchivePath;
    }

    return path;
}
