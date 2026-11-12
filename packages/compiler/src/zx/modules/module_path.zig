const std = @import("std");
const zx = @import("zx");
const generated = @import("parser_options").generated_parser;

pub fn index(allocator: std.mem.Allocator, candidate: []const u8) std.mem.Allocator.Error![]const u8 {
    std.debug.assert(std.mem.endsWith(u8, candidate, ".zx"));

    return indexFor(allocator, candidate[0 .. candidate.len - ".zx".len], false);
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

    if (comptime generated) {
        const directory_kind = @import("generated_module_directory");
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const input: std.meta.Child(directory_kind.Input) = .{ .path = path, .basename = name };

        return zx.columns.invoke(directory_kind.executeValue, empty.allocator(), &input) catch unreachable;
    }

    return std.mem.endsWith(u8, path, "/") or std.mem.eql(u8, name, ".") or std.mem.eql(u8, name, "..");
}

pub fn directory(allocator: std.mem.Allocator, path: []const u8) std.mem.Allocator.Error![]const u8 {
    return directoryFor(allocator, path, false);
}

pub fn directoryFor(allocator: std.mem.Allocator, path: []const u8, rx: bool) std.mem.Allocator.Error![]const u8 {
    return indexFor(allocator, std.mem.trimEnd(u8, path, "/"), rx);
}

fn indexFor(allocator: std.mem.Allocator, path: []const u8, rx: bool) std.mem.Allocator.Error![]const u8 {
    if (comptime generated) {
        const target = @import("generated_module_path");
        const input: std.meta.Child(target.Input) = .{ .directory = path, .rx = rx };

        return zx.columns.invoke(target.executeValue, allocator, &input) catch |err| switch (err) {
            error.OutOfMemory, error.WriteFailed => error.OutOfMemory,
        };
    }

    return std.fs.path.join(allocator, &.{ path, if (rx) "index.rx" else "index.zx" });
}
