const std = @import("std");
const Self = @This();

pub const State = union(enum) {
    missing,
    failed: anyerror,
    other: std.Io.File.Kind,
    file: Content,
    directory: Content,
};

pub const Content = struct { digest: [32]u8, physical_path: []const u8 };
pub const Entry = struct { path: []const u8, state: State, directory_entries: bool = false };

arena: std.heap.ArenaAllocator,
entries: []const Entry,

consistent: bool = true,
pub fn capture(io: std.Io, allocator: std.mem.Allocator, paths: []const []const u8) !Self {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const cwd = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", owned);
    var seen: std.StringHashMapUnmanaged(void) = .empty;
    var entries: std.ArrayList(Entry) = .empty;

    for (paths) |path| {
        const normalized = try std.fs.path.resolve(owned, &.{ cwd, path });
        const entry = try seen.getOrPut(owned, normalized);

        if (entry.found_existing) continue;
        try entries.append(owned, .{ .path = normalized, .state = try read(io, owned, normalized) });
    }

    std.mem.sort(Entry, entries.items, {}, lessThan);

    const result = try entries.toOwnedSlice(owned);

    return .{ .arena = arena, .entries = result };
}

pub fn deinit(self: *Self) void {
    self.arena.deinit();

    self.* = undefined;
}

pub fn refresh(self: Self, io: std.Io, allocator: std.mem.Allocator) !Self {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const entries = try owned.alloc(Entry, self.entries.len);

    for (self.entries, entries) |previous, *entry| {
        const path = try owned.dupe(u8, previous.path);
        entry.* = .{ .path = path, .state = try readWithDirectoryEntries(io, owned, path, previous.directory_entries), .directory_entries = previous.directory_entries };
    }

    return .{ .arena = arena, .entries = entries };
}

pub fn same(self: Self, other: Self) bool {
    if (!self.consistent or !other.consistent) return false;
    if (self.entries.len != other.entries.len) return false;

    for (self.entries, other.entries) |left, right| {
        if (!std.mem.eql(u8, left.path, right.path) or left.directory_entries != right.directory_entries or std.meta.activeTag(left.state) != std.meta.activeTag(right.state)) return false;
        if (!sameState(left.state, right.state)) return false;
    }

    return true;
}

pub fn sameState(left: State, right: State) bool {
    if (std.meta.activeTag(left) != std.meta.activeTag(right)) return false;

    return switch (left) {
        .missing => true,
        .failed => |err| err == right.failed,
        .other => |kind| kind == right.other,
        .directory => |directory| std.mem.eql(u8, &directory.digest, &right.directory.digest) and std.mem.eql(u8, directory.physical_path, right.directory.physical_path),
        .file => |file| std.mem.eql(u8, &file.digest, &right.file.digest) and std.mem.eql(u8, file.physical_path, right.file.physical_path),
    };
}

pub fn read(io: std.Io, allocator: std.mem.Allocator, path: []const u8) !State {
    return readWithDirectoryEntries(io, allocator, path, false);
}

pub fn readWithDirectoryEntries(io: std.Io, allocator: std.mem.Allocator, path: []const u8, directory_entries: bool) !State {
    const stat = std.Io.Dir.cwd().statFile(io, path, .{}) catch |err| switch (err) {
        error.FileNotFound, error.NotDir => return .missing,
        else => return err,
    };

    if (stat.kind == .directory) return .{ .directory = .{
        .digest = if (directory_entries) try @import("directory.zig").digest(io, allocator, path) else try @import("../../package/workspace/directory.zig").digest(io, allocator, path),
        .physical_path = try std.Io.Dir.cwd().realPathFileAlloc(io, path, allocator),
    } };

    if (stat.kind != .file) return .{ .other = stat.kind };

    const file = std.Io.Dir.cwd().openFile(io, path, .{}) catch |err| switch (err) {
        error.FileNotFound, error.NotDir => return .missing,
        else => return err,
    };

    defer file.close(io);

    var buffer: [8192]u8 = undefined;
    var reader = file.reader(io, &buffer);
    var bytes: [8192]u8 = undefined;
    var hash = std.crypto.hash.sha2.Sha256.init(.{});

    while (true) {
        const count = try reader.interface.readSliceShort(&bytes);

        hash.update(bytes[0..count]);

        if (count != bytes.len) break;
    }

    var digest: [32]u8 = undefined;

    hash.final(&digest);

    const physical = try std.Io.Dir.cwd().realPathFileAlloc(io, path, allocator);

    return .{ .file = .{ .digest = digest, .physical_path = physical } };
}

fn lessThan(_: void, left: Entry, right: Entry) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}
