const std = @import("std");
const Self = @This();
const envelope = @import("envelope.zig");
const stack_capacity = 256;

io: std.Io,
directory: []const u8,
compiler_hex: [64]u8,
pub fn read(self: Self, allocator: std.mem.Allocator, key: [32]u8) !?[]u8 {
    const key_hex = std.fmt.bytesToHex(key, .lower);
    const path = try self.filePath(allocator, &key_hex);

    defer allocator.free(path);

    const file = std.Io.Dir.cwd().openFile(self.io, path, .{}) catch |err| switch (err) {
        error.FileNotFound => return null,
        else => return err,
    };

    defer file.close(self.io);

    var buffer: [stack_capacity]u8 = undefined;
    const expected = self.header(&buffer, &key_hex, try file.length(self.io), true) orelse return error.InvalidCache;
    var received: [stack_capacity]u8 = undefined;
    const recorded = received[0..expected.bytes.len];

    if (try file.readPositionalAll(self.io, recorded, 0) != recorded.len) return error.InvalidCache;
    if (!std.mem.eql(u8, recorded, expected.bytes)) return error.InvalidCache;

    const source = try allocator.alloc(u8, expected.payload_size);

    errdefer allocator.free(source);

    if (try file.readPositionalAll(self.io, source, recorded.len) != source.len) return error.InvalidCache;

    return source;
}

pub fn write(self: Self, allocator: std.mem.Allocator, key: [32]u8, source: []const u8) !bool {
    const key_hex = std.fmt.bytesToHex(key, .lower);
    var buffer: [stack_capacity]u8 = undefined;
    const header_bytes = (self.header(&buffer, &key_hex, source.len, false) orelse return false).bytes;
    const path = try self.filePath(allocator, &key_hex);

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

    try file.writeStreamingAll(self.io, header_bytes);
    try file.writeStreamingAll(self.io, source);

    return true;
}

/// A record is written in place rather than through a temporary file and a rename, which cost more than the write
/// itself. Every record of a key holds the same bytes, and the header holds the source length, so a record cut short
/// or caught mid-write reads as invalid and is generated again.
fn header(self: *const Self, buffer: []u8, key: []const u8, size: u64, reading: bool) ?envelope.Header {
    if (@import("parser_options").generated_parser) return envelope.prepare(buffer, &self.compiler_hex, key, size, reading);

    const marker = "zxc.zig.source.v2\n";
    const header_size = marker.len + 2 * 65 + 17;
    const maximum_source = 64 * 1024 * 1024;

    if (reading and size < header_size) return null;

    const payload_size = if (reading) size - header_size else size;

    if (payload_size > maximum_source) return null;

    const bytes = std.fmt.bufPrint(buffer, marker ++ "{s}\n{s}\n{x:0>16}\n", .{ &self.compiler_hex, key, payload_size }) catch unreachable;

    return .{ .bytes = bytes, .payload_size = @intCast(payload_size) };
}

fn filePath(self: Self, allocator: std.mem.Allocator, key: []const u8) std.mem.Allocator.Error![]u8 {
    return std.fmt.allocPrint(allocator, "{s}/{s}.cache", .{ self.directory, key });
}
