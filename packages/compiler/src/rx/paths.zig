const std = @import("std");

pub const Error = error{ InvalidPath, OutOfMemory };

pub fn isModuleFile(path: []const u8) bool {
    if (@import("rx_options").generated_paths) return @import("path_kind/adapter.zig").check(path, &.{}, .ModuleFile);

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

    return normalizeSegments(allocator, path);
}

pub fn normalizeGateway(allocator: std.mem.Allocator, path: []const u8) Error![]const u8 {
    return normalizeSpecial(allocator, path, ".gateway.rx");
}

pub fn normalizeStore(allocator: std.mem.Allocator, path: []const u8) Error![]const u8 {
    return normalizeSpecial(allocator, path, ".store.rx");
}

fn normalizeSpecial(allocator: std.mem.Allocator, path: []const u8, suffix: []const u8) Error![]const u8 {
    if (@import("rx_options").generated_paths) {
        if (!@import("path_kind/adapter.zig").check(path, suffix, .SpecialFile)) return error.InvalidPath;

        return normalizeSegments(allocator, path);
    }

    const name = std.fs.path.basename(path);

    if (path.len == 0 or path[0] == '/' or path[path.len - 1] == '/' or
        std.mem.indexOfAny(u8, path, "\\:\x00") != null or
        !std.mem.endsWith(u8, name, suffix) or name.len <= suffix.len) return error.InvalidPath;

    return normalizeSegments(allocator, path);
}

fn normalizeSegments(allocator: std.mem.Allocator, path: []const u8) Error![]const u8 {
    if (@import("rx_options").generated_paths) return @import("path_segments/adapter.zig").normalize(allocator, path);

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
    if (@import("rx_options").generated_paths) return @import("path_kind/adapter.zig").check(path, &.{}, .ModuleReference);
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

pub fn resolveStore(allocator: std.mem.Allocator, owner: []const u8, reference: []const u8) Error![]const u8 {
    if (@import("rx_options").generated_paths) {
        if (!@import("path_kind/adapter.zig").check(reference, &.{}, .StoreReference)) return error.InvalidPath;
    } else {
        const name = std.fs.path.basename(reference);

        if (reference.len == 0 or reference[0] == '/' or reference[reference.len - 1] == '/' or
            std.mem.indexOfAny(u8, reference, "\\:\x00") != null or
            std.mem.eql(u8, name, ".") or std.mem.eql(u8, name, "..")) return error.InvalidPath;
    }

    const has_suffix = std.mem.endsWith(u8, reference, ".store.rx");

    if (!@import("rx_options").generated_paths and std.mem.endsWith(u8, reference, ".rx") and !has_suffix) return error.InvalidPath;

    const joined = try std.fmt.allocPrint(allocator, "{s}/{s}{s}", .{
        std.fs.path.dirname(owner) orelse ".",
        reference,
        if (has_suffix) "" else ".store.rx",
    });

    defer allocator.free(joined);

    return normalizeStore(allocator, joined);
}

pub fn resolveFunction(allocator: std.mem.Allocator, owner: []const u8, reference: []const u8) Error![]const u8 {
    if (@import("rx_options").generated_paths) {
        if (!@import("path_kind/adapter.zig").check(reference, &.{}, .FunctionReference)) return error.InvalidPath;
    } else {
        const name = std.fs.path.basename(reference);

        if (reference.len == 0 or reference[0] == '/' or reference[reference.len - 1] == '/' or
            std.mem.indexOfAny(u8, reference, "\\:\x00") != null or
            std.mem.eql(u8, name, ".") or std.mem.eql(u8, name, "..") or
            std.mem.endsWith(u8, reference, ".rx")) return error.InvalidPath;
    }

    const joined = try std.fmt.allocPrint(allocator, "{s}/{s}{s}", .{
        std.fs.path.dirname(owner) orelse ".",
        reference,
        if (std.mem.endsWith(u8, reference, ".zx")) "" else ".zx",
    });

    defer allocator.free(joined);

    return normalizeSpecial(allocator, joined, ".zx");
}
