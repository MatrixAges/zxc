const std = @import("std");
const Self = @This();
const Hash = std.crypto.hash.sha2.Sha256;
const marker = "zxc.zig.source.v1\n";
const header_size = marker.len + 3 * 65;
const maximum_source = 64 * 1024 * 1024;

io: std.Io,
directory: []const u8,
compiler_digest: [32]u8,
pub fn read(self: Self, allocator: std.mem.Allocator, key: [32]u8) !?[]u8 {
    const path = try self.filePath(allocator, key);

    defer allocator.free(path);

    const content = std.Io.Dir.cwd().readFileAlloc(self.io, path, allocator, .limited(header_size + maximum_source + 1)) catch |err| switch (err) {
        error.FileNotFound => return null,
        error.StreamTooLong => return error.InvalidCache,
        else => return err,
    };

    defer allocator.free(content);

    if (content.len < header_size or content.len > header_size + maximum_source) return error.InvalidCache;

    const source = content[header_size..];
    var buffer: [header_size]u8 = undefined;
    const expected = self.header(&buffer, key, source);

    if (!std.mem.eql(u8, content[0..header_size], expected)) return error.InvalidCache;

    return try allocator.dupe(u8, source);
}

pub fn write(self: Self, allocator: std.mem.Allocator, key: [32]u8, source: []const u8) !bool {
    if (source.len > maximum_source) return false;

    const path = try self.filePath(allocator, key);

    defer allocator.free(path);

    var file = try std.Io.Dir.cwd().createFileAtomic(self.io, path, .{ .make_path = true, .replace = true });

    defer file.deinit(self.io);

    var buffer: [header_size]u8 = undefined;

    try file.file.writeStreamingAll(self.io, self.header(&buffer, key, source));
    try file.file.writeStreamingAll(self.io, source);
    try file.replace(self.io);

    return true;
}

fn header(self: Self, buffer: *[header_size]u8, key: [32]u8, source: []const u8) []const u8 {
    var digest: [32]u8 = undefined;

    Hash.hash(source, &digest, .{});

    return std.fmt.bufPrint(buffer, marker ++ "{s}\n{s}\n{s}\n", .{ std.fmt.bytesToHex(self.compiler_digest, .lower), std.fmt.bytesToHex(key, .lower), std.fmt.bytesToHex(digest, .lower) }) catch unreachable;
}

fn filePath(self: Self, allocator: std.mem.Allocator, key: [32]u8) std.mem.Allocator.Error![]u8 {
    return std.fmt.allocPrint(allocator, "{s}/{s}.cache", .{ self.directory, std.fmt.bytesToHex(key, .lower) });
}
