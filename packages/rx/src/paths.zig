const std = @import("std");

pub const Error = error{ InvalidPath, OutOfMemory };

pub fn isModuleFile(path: []const u8) bool {
    const name = std.fs.path.basename(path);

    return path.len > 0 and path[0] != '/' and path[path.len - 1] != '/' and
        std.mem.indexOfAny(u8, path, "\\:\x00") == null and
        std.mem.endsWith(u8, name, ".rx") and name.len > 3 and
        !std.mem.eql(u8, name, "app.rx") and
        !std.mem.endsWith(u8, name, ".gateway.rx") and
        !std.mem.endsWith(u8, name, ".store.rx");
}

pub fn normalize(allocator: std.mem.Allocator, path: []const u8) Error![]const u8 {
    if (!isModuleFile(path)) return error.InvalidPath;

    var segments: std.ArrayList([]const u8) = .empty;

    defer segments.deinit(allocator);

    var parts = std.mem.splitScalar(u8, path, '/');

    while (parts.next()) |part| {
        if (part.len == 0 or std.mem.eql(u8, part, ".")) continue;

        if (std.mem.eql(u8, part, "..")) {
            if (segments.pop() == null) return error.InvalidPath;
        } else {
            try segments.append(allocator, part);
        }
    }

    return std.mem.join(allocator, "/", segments.items);
}

pub fn isModuleReference(path: []const u8) bool {
    if (std.mem.endsWith(u8, path, ".rx")) return isModuleFile(path);

    const name = std.fs.path.basename(path);

    return path.len > 0 and path[0] != '/' and path[path.len - 1] != '/' and
        std.mem.indexOfAny(u8, path, "\\:\x00") == null and
        name.len > 0 and !std.mem.eql(u8, name, ".") and !std.mem.eql(u8, name, "..") and
        !std.mem.eql(u8, name, "app") and
        !std.mem.endsWith(u8, name, ".gateway") and !std.mem.endsWith(u8, name, ".store");
}

pub fn resolve(allocator: std.mem.Allocator, owner: []const u8, reference: []const u8) Error![]const u8 {
    if (!isModuleReference(reference)) return error.InvalidPath;

    const directory = std.fs.path.dirname(owner) orelse ".";

    const joined = try std.fmt.allocPrint(allocator, "{s}/{s}{s}", .{
        directory,
        reference,
        if (std.mem.endsWith(u8, reference, ".rx")) "" else ".rx",
    });

    defer allocator.free(joined);

    return normalize(allocator, joined);
}
