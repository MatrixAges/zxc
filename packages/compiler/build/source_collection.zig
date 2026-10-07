const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");

pub fn lessSource(_: void, left: compiler.project.Source, right: compiler.project.Source) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}

pub fn lessModule(_: void, left: rx.TextSource, right: rx.TextSource) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}

pub fn collect(io: std.Io, allocator: std.mem.Allocator, root: []const u8, prefix: []const u8, sources: *std.ArrayList(compiler.project.Source), modules: *std.ArrayList(rx.TextSource)) !void {
    var directory = try std.Io.Dir.cwd().openDir(io, root, .{ .iterate = true });

    defer directory.close(io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    while (try walker.next(io)) |entry| {
        if (entry.kind != .file) continue;

        const is_zx = std.mem.endsWith(u8, entry.path, ".zx");
        const is_rx = std.mem.endsWith(u8, entry.path, ".rx");

        if (!is_zx and !is_rx) continue;

        const path = try std.mem.concat(allocator, u8, &.{ prefix, entry.path });

        if (std.fs.path.sep == '\\') for (path) |*byte| if (byte.* == '\\') {
            byte.* = '/';
        };

        const source = try directory.readFileAlloc(io, entry.path, allocator, .unlimited);

        if (is_zx) try sources.append(allocator, .{ .path = path, .source = source }) else try modules.append(allocator, .{ .path = path, .source = source });
    }
}
