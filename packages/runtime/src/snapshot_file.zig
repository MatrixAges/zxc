const std = @import("std");
const format = @import("snapshot_file/format.zig");
const Self = @This();

allocator: std.mem.Allocator,
directory: std.Io.Dir,
metadata: format.Metadata,
key: [64]u8,
limit: std.Io.Limit,
pub const Metadata = format.Metadata;

pub const Options = struct { metadata: Metadata, limit: std.Io.Limit = .unlimited };

pub fn init(allocator: std.mem.Allocator, directory: std.Io.Dir, options: Options) Self {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(options.metadata.identity, &digest, .{});

    return .{ .allocator = allocator, .directory = directory, .metadata = options.metadata, .key = std.fmt.bytesToHex(digest, .lower), .limit = options.limit };
}

pub fn Loaded(comptime T: type) type {
    return struct { revision: u64, value: T };
}

pub fn load(self: *const Self, comptime T: type, io: std.Io, arena: *std.heap.ArenaAllocator, initialize: anytype) !Loaded(T) {
    const lock = try self.lockFile(io);

    defer lock.close(io);

    if (try self.read(io, arena.allocator())) |snapshot| {
        return .{ .revision = snapshot.revision, .value = try std.json.parseFromValueLeaky(T, arena.allocator(), snapshot.value, .{}) };
    }

    const value = try initialize(arena, {});

    try self.write(io, 0, value);

    return .{ .revision = 0, .value = value };
}

pub fn save(self: *const Self, io: std.Io, previous: u64, next: u64, value: anytype) !void {
    if (next != (std.math.add(u64, previous, 1) catch return error.RevisionExhausted)) return error.InvalidRevision;

    var arena = std.heap.ArenaAllocator.init(self.allocator);

    defer arena.deinit();

    const lock = try self.lockFile(io);

    defer lock.close(io);

    const snapshot = (try self.read(io, arena.allocator())) orelse return error.MissingSnapshot;

    if (snapshot.revision != previous) return error.Conflict;

    _ = try std.json.parseFromValueLeaky(@TypeOf(value), arena.allocator(), snapshot.value, .{});

    try self.write(io, next, value);
}

pub fn sync(self: *const Self, io: std.Io) !void {
    const directory = try self.directory.openFile(io, ".", .{ .allow_directory = true });

    defer directory.close(io);

    try directory.sync(io);
}

fn lockFile(self: *const Self, io: std.Io) !std.Io.File {
    var name: [69]u8 = undefined;
    const lock = try self.directory.createFile(io, try std.fmt.bufPrint(&name, "{s}.lock", .{self.key}), .{ .truncate = false });

    errdefer lock.close(io);

    try lock.lock(io, .exclusive);

    return lock;
}

fn read(self: *const Self, io: std.Io, allocator: std.mem.Allocator) !?format.Snapshot {
    var name: [69]u8 = undefined;

    const source = self.directory.readFileAlloc(io, try std.fmt.bufPrint(&name, "{s}.json", .{self.key}), allocator, self.limit) catch |err| switch (err) {
        error.FileNotFound => return null,
        else => return err,
    };

    return try format.parse(allocator, source, self.metadata);
}

fn write(self: *const Self, io: std.Io, revision: u64, value: anytype) !void {
    const source = try format.encode(self.allocator, self.metadata, revision, value);

    defer self.allocator.free(source);

    if (self.limit.toInt()) |limit| if (source.len > limit) return error.StreamTooLong;

    var name: [69]u8 = undefined;
    var file = try self.directory.createFileAtomic(io, try std.fmt.bufPrint(&name, "{s}.json", .{self.key}), .{ .replace = true });

    defer file.deinit(io);

    try file.file.writeStreamingAll(io, source);
    try file.file.sync(io);
    try file.replace(io);
}
