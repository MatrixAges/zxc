const std = @import("std");
const Self = @This();
const marker = "zxc.zig.source.v2\n";
const header_size = marker.len + 2 * 65 + 17;
const maximum_source = 64 * 1024 * 1024;

io: std.Io,
directory: []const u8,
compiler_digest: [32]u8,
pub fn read(self: Self, allocator: std.mem.Allocator, key: [32]u8) !?[]u8 {
    const path = try self.filePath(allocator, key);

    defer allocator.free(path);

    const file = std.Io.Dir.cwd().openFile(self.io, path, .{}) catch |err| switch (err) {
        error.FileNotFound => return null,
        else => return err,
    };

    defer file.close(self.io);

    const length = try file.length(self.io);

    if (length < header_size or length > header_size + maximum_source) return error.InvalidCache;

    // The header goes to the stack and the source straight to its own allocation, so a hit copies nothing.
    var recorded: [header_size]u8 = undefined;
    const source = try allocator.alloc(u8, @intCast(length - header_size));

    errdefer allocator.free(source);

    if (try file.readPositionalAll(self.io, &recorded, 0) != header_size) return error.InvalidCache;
    if (try file.readPositionalAll(self.io, source, header_size) != source.len) return error.InvalidCache;

    var buffer: [header_size]u8 = undefined;

    if (!std.mem.eql(u8, &recorded, self.header(&buffer, key, source))) return error.InvalidCache;

    return source;
}

pub fn write(self: Self, allocator: std.mem.Allocator, key: [32]u8, source: []const u8) !bool {
    if (source.len > maximum_source) return false;

    const path = try self.filePath(allocator, key);

    defer allocator.free(path);

    const directory = std.Io.Dir.cwd();

    const file = directory.createFile(self.io, path, .{}) catch |err| switch (err) {
        error.FileNotFound => created: {
            try directory.createDirPath(self.io, self.directory);

            break :created try directory.createFile(self.io, path, .{});
        },
        else => return err,
    };

    defer file.close(self.io);

    var buffer: [header_size]u8 = undefined;

    try file.writeStreamingAll(self.io, self.header(&buffer, key, source));
    try file.writeStreamingAll(self.io, source);

    return true;
}

/// A record is written in place rather than through a temporary file and a rename, which cost more than the write
/// itself. Every record of a key holds the same bytes, and the header holds the source length, so a record cut short
/// or caught mid-write reads as invalid and is generated again.
fn header(self: Self, buffer: *[header_size]u8, key: [32]u8, source: []const u8) []const u8 {
    return std.fmt.bufPrint(buffer, marker ++ "{s}\n{s}\n{x:0>16}\n", .{ std.fmt.bytesToHex(self.compiler_digest, .lower), std.fmt.bytesToHex(key, .lower), source.len }) catch unreachable;
}

fn filePath(self: Self, allocator: std.mem.Allocator, key: [32]u8) std.mem.Allocator.Error![]u8 {
    return std.fmt.allocPrint(allocator, "{s}/{s}.cache", .{ self.directory, std.fmt.bytesToHex(key, .lower) });
}
