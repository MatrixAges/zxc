const std = @import("std");
const Inputs = @import("../watch/inputs.zig");

pub fn files(io: std.Io, allocator: std.mem.Allocator, path: []const u8, inputs: ?*Inputs) ![]const []const u8 {
    if (inputs) |observed| try observed.add(io, path);

    const stat = try std.Io.Dir.cwd().statFile(io, path, .{});
    var paths: std.ArrayList([]const u8) = .empty;

    if (stat.kind == .file) {
        try paths.append(allocator, path);

        return paths.items;
    }

    if (stat.kind != .directory) return error.UnsupportedNativeResource;
    if (inputs) |observed| try observed.addDirectory(io, path);

    var directory = try std.Io.Dir.cwd().openDir(io, path, .{ .iterate = true, .follow_symlinks = false });

    defer directory.close(io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    while (try walker.next(io)) |entry| {
        const absolute = try std.fs.path.join(allocator, &.{ path, entry.path });

        if (entry.kind == .directory) {
            if (inputs) |observed| try observed.addDirectory(io, absolute);

            continue;
        }

        if (inputs) |observed| try observed.add(io, absolute);

        if (entry.kind != .file) {
            if (entry.kind != .sym_link or (try std.Io.Dir.cwd().statFile(io, absolute, .{})).kind != .file) return error.UnsupportedNativeResource;
        }

        try paths.append(allocator, absolute);
    }

    std.mem.sort([]const u8, paths.items, {}, lessThan);

    return paths.items;
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
