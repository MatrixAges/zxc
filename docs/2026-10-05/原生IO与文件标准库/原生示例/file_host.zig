const std = @import("std");

pub fn echo(io: []const u8) []const u8 {
    return io;
}

pub fn size(io: std.Io, path: []const u8) !u64 {
    if (std.mem.indexOfScalar(u8, path, 0) != null) return error.InvalidPath;

    return (try std.Io.Dir.cwd().statFile(io, path, .{})).size;
}
