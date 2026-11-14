const std = @import("std");
const rules = @import("partition_rules");
const Io = std.Io;
const Blake3 = std.crypto.hash.Blake3;
pub const Digest = [Blake3.digest_length]u8;
const HashWriter = Io.Writer.Hashing(Blake3);
const buffer_size = 16 * 1024;

pub const Shared = struct {
    buffer: [buffer_size]u8 = undefined,
    writer: HashWriter = undefined,
    pub fn init(self: *Shared) void {
        self.writer = .init(&self.buffer);
    }

    pub fn prefix(self: *Shared, executable: []const u8, stat: Io.File.Stat, arguments: []const []const u8, types: u64, signatures: u64) void {
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const rule = rules.partition_cache_prefix;

        rule.executeValue(empty.allocator(), &.{
            .out = @ptrCast(&self.writer.writer),
            .executable = executable,
            .size = stat.size,
            .modified = @bitCast(@as(i64, @truncate(stat.mtime.nanoseconds))),
            .arguments = arguments,
            .types = types,
            .signatures = signatures,
        }) catch unreachable;
    }

    pub fn state(self: *Shared) Blake3 {
        self.writer.writer.flush() catch unreachable;

        return self.writer.hasher;
    }
    pub fn input(self: *Shared, io: Io, allocator: std.mem.Allocator, path: []const u8) !void {
        try inputPath(io, allocator, &self.writer, path);
    }
};

fn inputPath(io: Io, allocator: std.mem.Allocator, hash: *HashWriter, path: []const u8) !void {
    const cwd = Io.Dir.cwd();

    if ((try cwd.statFile(io, path, .{})).kind == .file) return file(io, cwd, hash, path);

    var directory = try cwd.openDir(io, path, .{ .iterate = true });

    defer directory.close(io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(io)) |entry| if (entry.kind == .file) try paths.append(allocator, try allocator.dupe(u8, entry.path));

    std.mem.sort([]const u8, paths.items, {}, lessThan);
    external(hash, path, null);
    for (paths.items) |child| try file(io, directory, hash, child);
}

fn file(io: Io, directory: Io.Dir, hash: *HashWriter, path: []const u8) !void {
    const handle = try directory.openFile(io, path, .{});

    defer handle.close(io);

    const size = try handle.length(io);

    external(hash, path, size);
    hash.writer.flush() catch unreachable;

    var offset: u64 = 0;

    while (offset < size) {
        const length: usize = @intCast(@min(hash.writer.buffer.len, size - offset));
        const block = hash.writer.buffer[0..length];

        if (try handle.readPositionalAll(io, block, offset) != length) return error.FileChanged;

        hash.hasher.update(block);

        offset += length;
    }

    if (try handle.length(io) != size) return error.FileChanged;
}

fn external(hash: *HashWriter, path: []const u8, size: ?u64) void {
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const rule = rules.partition_cache_external;

    rule.executeValue(empty.allocator(), &.{ .out = @ptrCast(&hash.writer), .path = path, .size = size }) catch unreachable;
}

pub fn partitions(allocator: std.mem.Allocator, count: u32, shared: Blake3, manifest: *const std.StringHashMapUnmanaged(u64)) ![]Digest {
    const groups = try allocator.alloc(std.ArrayList(Member), count);

    @memset(groups, .empty);

    var entries = manifest.iterator();

    while (entries.next()) |entry| {
        const path = entry.key_ptr.*;

        if (!std.mem.startsWith(u8, path, "part_")) continue;

        const slash = std.mem.indexOfScalar(u8, path, '/') orelse continue;
        const index = std.fmt.parseInt(u32, path["part_".len..slash], 10) catch continue;

        if (index < count) try groups[index].append(allocator, .{ .path = path, .hash = entry.value_ptr.* });
    }

    const digests = try allocator.alloc(Digest, count);

    for (groups, digests) |group, *digest| {
        std.mem.sort(Member, group.items, {}, Member.less);
        members(shared, group.items, digest);
    }

    return digests;
}

const Member = struct {
    path: []const u8,
    hash: u64,
    fn less(_: void, left: Member, right: Member) bool {
        return std.mem.lessThan(u8, left.path, right.path);
    }
};

fn members(shared: Blake3, group: []const Member, digest: *Digest) void {
    var buffer: [1024]u8 = undefined;
    const batch_size = 64;
    var paths: [batch_size][]const u8 = undefined;
    var hashes: [batch_size]u64 = undefined;
    var stream: HashWriter = .initHasher(shared, &buffer);
    var empty = std.heap.FixedBufferAllocator.init(&.{});
    const rule = rules.partition_cache_members;
    var remaining = group;

    while (remaining.len != 0) {
        const count = @min(remaining.len, batch_size);

        for (remaining[0..count], paths[0..count], hashes[0..count]) |member, *path, *hash| {
            path.* = member.path;
            hash.* = member.hash;
        }

        rule.executeValue(empty.allocator(), &.{ .out = @ptrCast(&stream.writer), .paths = paths[0..count], .hashes = hashes[0..count] }) catch unreachable;

        remaining = remaining[count..];
    }

    stream.writer.flush() catch unreachable;
    stream.hasher.final(digest);
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
