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
pub const Entry = struct { path: []const u8, state: State };

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

pub fn same(self: Self, other: Self) bool {
    if (!self.consistent or !other.consistent) return false;
    if (self.entries.len != other.entries.len) return false;

    for (self.entries, other.entries) |left, right| {
        if (!std.mem.eql(u8, left.path, right.path) or std.meta.activeTag(left.state) != std.meta.activeTag(right.state)) return false;

        switch (left.state) {
            .missing => {},
            .failed => |err| if (err != right.state.failed) return false,
            .other => |kind| if (kind != right.state.other) return false,
            .directory => |directory| if (!std.mem.eql(u8, &directory.digest, &right.state.directory.digest) or !std.mem.eql(u8, directory.physical_path, right.state.directory.physical_path)) return false,
            .file => |file| if (!std.mem.eql(u8, &file.digest, &right.state.file.digest) or !std.mem.eql(u8, file.physical_path, right.state.file.physical_path)) return false,
        }
    }

    return true;
}

pub fn read(io: std.Io, allocator: std.mem.Allocator, path: []const u8) !State {
    const stat = std.Io.Dir.cwd().statFile(io, path, .{}) catch |err| switch (err) {
        error.FileNotFound, error.NotDir => return .missing,
        else => return err,
    };

    if (stat.kind == .directory) return .{ .directory = .{
        .digest = try @import("../../package/workspace/directory.zig").digest(io, allocator, path),
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
