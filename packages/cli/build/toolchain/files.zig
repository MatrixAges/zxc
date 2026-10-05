const std = @import("std");
const File = @import("manifest.zig").File;

pub fn append(b: *std.Build, files: *std.ArrayList(File), source: []const u8, destination: []const u8) !void {
    b.dependOnDirectoryContents(.{ .cwd_relative = source });

    var directory = try std.Io.Dir.cwd().openDir(b.graph.io, source, .{ .iterate = true });

    defer directory.close(b.graph.io);

    var walker = try directory.walk(b.allocator);

    defer walker.deinit();

    while (try walker.next(b.graph.io)) |entry| {
        if (entry.kind == .directory) {
            b.dependOnDirectoryContents(.{ .cwd_relative = try std.fs.path.join(b.allocator, &.{ source, entry.path }) });

            continue;
        }

        if (entry.kind != .file) return error.UnsupportedToolchainFile;

        const path = try std.fs.path.join(b.allocator, &.{ destination, entry.path });

        std.mem.replaceScalar(u8, path, '\\', '/');

        try files.append(b.allocator, .{ .source = try std.fs.path.join(b.allocator, &.{ source, entry.path }), .destination = path });
    }
}

pub fn lessThan(_: void, left: File, right: File) bool {
    return std.mem.lessThan(u8, left.destination, right.destination);
}
