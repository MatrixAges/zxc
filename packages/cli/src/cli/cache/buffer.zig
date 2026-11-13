const std = @import("std");

pub fn read(out: *std.Io.Writer.Allocating, io: std.Io, path: []const u8, limit: usize) ![]const u8 {
    const file = try std.Io.Dir.cwd().openFile(io, path, .{
        .allow_directory = @import("builtin").os.tag != .windows,
    });

    defer file.close(io);
    out.clearRetainingCapacity();

    var bytes = out.toArrayList();

    defer out.* = .fromArrayList(out.allocator, &bytes);

    var reader = file.reader(io, &.{});

    reader.interface.appendRemaining(out.allocator, &bytes, .limited(limit)) catch |err| switch (err) {
        error.ReadFailed => return reader.err.?,
        error.OutOfMemory, error.StreamTooLong => |failure| return failure,
    };

    return bytes.items;
}
