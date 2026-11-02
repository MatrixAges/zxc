const std = @import("std");
const api = @import("zxc_abi").native.@"std:fs";
const path = @import("path.zig");
const Allocator = std.mem.Allocator;

pub fn mkdir(io: std.Io, input: api.mkdir.Input) !void {
    try path.validate(input.path);

    if (input.recursive) {
        try std.Io.Dir.cwd().createDirPath(io, input.path);
    } else try std.Io.Dir.cwd().createDir(io, input.path, .default_dir);
}

pub fn readdir(allocator: Allocator, io: std.Io, input: []const u8) ![]const []const u8 {
    try path.validate(input);

    const directory = try std.Io.Dir.cwd().openDir(io, input, .{ .iterate = true });

    defer directory.close(io);

    var entries: std.ArrayList([]const u8) = .empty;

    errdefer {
        for (entries.items) |entry| allocator.free(entry);

        entries.deinit(allocator);
    }

    var iterator = directory.iterate();

    while (try iterator.next(io)) |entry| {
        if (!std.unicode.utf8ValidateSlice(entry.name)) return error.InvalidUtf8;
        try entries.ensureUnusedCapacity(allocator, 1);

        entries.appendAssumeCapacity(try allocator.dupe(u8, entry.name));
    }

    return entries.toOwnedSlice(allocator);
}

pub fn rmdir(io: std.Io, input: []const u8) !void {
    try path.validate(input);
    try std.Io.Dir.cwd().deleteDir(io, input);
}
