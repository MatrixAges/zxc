const std = @import("std");
const references = @import("native_references.zig");
const artifacts = @import("artifacts.zig");
const NativeModule = @import("project.zig").NativeModule;
pub const File = struct { path: []const u8, kind: references.Kind, sha256: []const u8, referenced_from: ?[]const u8 };
pub const Result = struct { entry: []const u8, files: []const File, dynamic_resources: bool, c_imports: bool };
const Pending = struct { path: []const u8, kind: references.Kind, from: ?[]const u8 };
const Seen = struct { index: usize, parsed: bool, bytes: []const u8 };

pub fn write(io: std.Io, allocator: std.mem.Allocator, directory: []const u8, project_root: []const u8, module: NativeModule) !Result {
    const entry = try std.fs.path.resolve(allocator, &.{ project_root, module.path.? });
    const root = std.fs.path.dirname(entry).?;
    const canonical_root = try std.Io.Dir.cwd().realPathFileAlloc(io, root, allocator);
    const destination = try std.fs.path.join(allocator, &.{ "native", module.name, "source" });
    var pending: std.ArrayList(Pending) = .empty;
    var files: std.ArrayList(File) = .empty;
    var seen: std.StringHashMapUnmanaged(Seen) = .empty;
    var dynamic_resources = false;
    var c_imports = false;

    try pending.append(allocator, .{ .path = entry, .kind = .zig, .from = null });

    for (module.bundle_files) |path| {
        try pending.append(allocator, .{ .path = try referencedPath(allocator, root, root, path), .kind = .asset, .from = null });
    }

    var cursor: usize = 0;

    while (cursor < pending.items.len) : (cursor += 1) {
        const item = pending.items[cursor];
        const relative = try relativePath(allocator, root, item.path);
        const existing = seen.get(relative);

        if (existing) |previous| {
            if (previous.parsed or item.kind == .asset) continue;
        }

        const canonical = try std.Io.Dir.cwd().realPathFileAlloc(io, item.path, allocator);

        _ = try relativePath(allocator, canonical_root, canonical);

        const bytes = if (existing) |previous| previous.bytes else try std.Io.Dir.cwd().readFileAlloc(io, item.path, allocator, .unlimited);
        const target = try std.fs.path.join(allocator, &.{ destination, relative });

        if (existing) |previous| {
            files.items[previous.index].kind = .zig;

            seen.getPtr(relative).?.parsed = true;
        } else {
            var digest: [32]u8 = undefined;

            std.crypto.hash.sha2.Sha256.hash(bytes, &digest, .{});

            const hex = std.fmt.bytesToHex(digest, .lower);

            try artifacts.write(io, try std.fs.path.join(allocator, &.{ directory, target }), bytes);
            try seen.put(allocator, relative, .{ .index = files.items.len, .parsed = item.kind == .zig, .bytes = bytes });
            try files.append(allocator, .{ .path = target, .kind = item.kind, .sha256 = try allocator.dupe(u8, &hex), .referenced_from = item.from });
        }

        if (item.kind != .zig) continue;

        const parsed = try references.read(allocator, bytes);

        if (parsed.dynamic_resources and module.bundle_files.len == 0) return error.NativeBundleRequiresFiles;

        dynamic_resources = dynamic_resources or parsed.dynamic_resources;
        c_imports = c_imports or parsed.c_imports;

        for (parsed.references) |reference| {
            const path = try referencedPath(allocator, root, std.fs.path.dirname(item.path).?, reference.path);

            try pending.append(allocator, .{ .path = path, .kind = reference.kind, .from = target });
        }
    }

    return .{ .entry = try std.fs.path.join(allocator, &.{ destination, std.fs.path.basename(entry) }), .files = files.items, .dynamic_resources = dynamic_resources, .c_imports = c_imports };
}

fn referencedPath(allocator: std.mem.Allocator, root: []const u8, parent: []const u8, path: []const u8) ![]const u8 {
    if (path.len == 0 or std.mem.indexOfScalar(u8, path, 0) != null or std.fs.path.isAbsolute(path)) return error.InvalidNativeResourcePath;

    const absolute = try std.fs.path.resolve(allocator, &.{ parent, path });

    _ = try relativePath(allocator, root, absolute);

    return absolute;
}

fn relativePath(allocator: std.mem.Allocator, root: []const u8, absolute: []const u8) ![]const u8 {
    const relative = try std.fs.path.relative(allocator, root, null, root, absolute);

    if (std.fs.path.isAbsolute(relative) or std.mem.eql(u8, relative, "..") or std.mem.startsWith(u8, relative, ".." ++ std.fs.path.sep_str)) return error.NativeResourceOutsideModule;

    return relative;
}
