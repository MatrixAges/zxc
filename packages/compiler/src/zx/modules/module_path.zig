const std = @import("std");

pub fn index(allocator: std.mem.Allocator, candidate: []const u8) std.mem.Allocator.Error![]const u8 {
    std.debug.assert(std.mem.endsWith(u8, candidate, ".zx"));

    if (@import("parser_options").generated_parser) {
        return @import("generated_module_path").executeValue(allocator, candidate) catch |err| switch (err) {
            error.OutOfMemory, error.WriteFailed => error.OutOfMemory,
            else => unreachable,
        };
    }

    return std.fs.path.join(allocator, &.{ candidate[0 .. candidate.len - ".zx".len], "index.zx" });
}

pub fn select(allocator: std.mem.Allocator, candidate: []const u8, known: anytype) ![]const u8 {
    if (try known.has(candidate)) return candidate;
    if (!std.mem.endsWith(u8, candidate, ".zx")) return candidate;

    const fallback = try index(allocator, candidate);

    errdefer allocator.free(fallback);

    if (try known.has(fallback)) return fallback;

    allocator.free(fallback);

    return candidate;
}

pub fn directoryReference(path: []const u8) bool {
    const name = std.fs.path.basename(path);

    return std.mem.endsWith(u8, path, "/") or std.mem.eql(u8, name, ".") or std.mem.eql(u8, name, "..");
}

pub fn directory(allocator: std.mem.Allocator, path: []const u8) std.mem.Allocator.Error![]const u8 {
    const candidate = try std.fmt.allocPrint(allocator, "{s}.zx", .{std.mem.trimEnd(u8, path, "/")});

    defer allocator.free(candidate);

    return index(allocator, candidate);
}
