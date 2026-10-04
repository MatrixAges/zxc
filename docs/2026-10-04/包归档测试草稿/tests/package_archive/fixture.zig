const std = @import("std");
const archive = @import("package_archive");
const io = std.testing.io;

pub fn extract(allocator: std.mem.Allocator, source: []const u8, directory: std.Io.Dir) !archive.Result {
    var digest: [32]u8 = undefined;
    std.crypto.hash.sha2.Sha256.hash(source, &digest, .{});

    return archive.extract(io, allocator, source, digest, directory);
}

pub fn expectFailure(allocator: std.mem.Allocator, source: []const u8, expected: anyerror) !void {
    var temporary = std.testing.tmpDir(.{});
    defer temporary.cleanup();
    try temporary.dir.createDir(io, "output", .default_dir);
    var output = try temporary.dir.openDir(io, "output", .{});
    defer output.close(io);

    var result = extract(allocator, source, output) catch |err| {
        if (err == error.OutOfMemory) return err;

        try std.testing.expectEqual(expected, err);
        try std.testing.expectError(error.FileNotFound, temporary.dir.statFile(io, "escape", .{}));
        return;
    };
    defer result.deinit();

    return error.TestExpectedError;
}
