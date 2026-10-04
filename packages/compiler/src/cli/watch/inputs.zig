const std = @import("std");
const Snapshot = @import("snapshot.zig");
const Self = @This();
const Observation = struct { state: Snapshot.State, consumed: bool = false };

arena: std.heap.ArenaAllocator,
cwd: []const u8,
entries: std.StringHashMapUnmanaged(Observation) = .empty,
consistent: bool = true,
pub fn init(io: std.Io, allocator: std.mem.Allocator) !Self {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const cwd = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", arena.allocator());

    return .{ .arena = arena, .cwd = cwd };
}

pub fn deinit(self: *Self) void {
    self.arena.deinit();

    self.* = undefined;
}

pub fn add(self: *Self, io: std.Io, path: []const u8) !void {
    const normalized = try std.fs.path.resolve(self.arena.allocator(), &.{ self.cwd, path });
    const entry = try self.entries.getOrPut(self.arena.allocator(), normalized);

    if (entry.found_existing) return;

    const state = Snapshot.read(io, self.arena.allocator(), normalized) catch |err| {
        entry.value_ptr.* = .{ .state = .{ .failed = err } };

        return err;
    };

    entry.value_ptr.* = .{ .state = state };
}

pub fn record(self: *Self, io: std.Io, path: []const u8, source: []const u8) !void {
    const allocator = self.arena.allocator();
    const normalized = try std.fs.path.resolve(allocator, &.{ self.cwd, path });
    const entry = try self.entries.getOrPut(allocator, normalized);

    const physical = std.Io.Dir.cwd().realPathFileAlloc(io, normalized, allocator) catch |err| {
        self.consistent = false;
        entry.value_ptr.* = .{ .state = .{ .failed = err } };

        return err;
    };

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(source, &digest, .{});

    if (entry.found_existing and entry.value_ptr.consumed) {
        const same = switch (entry.value_ptr.state) {
            .file => |previous| std.mem.eql(u8, &previous.digest, &digest) and std.mem.eql(u8, previous.physical_path, physical),
            else => false,
        };

        self.consistent = self.consistent and same;
    }

    entry.value_ptr.* = .{ .state = .{ .file = .{ .digest = digest, .physical_path = physical } }, .consumed = true };
}

pub fn observed(self: *const Self, allocator: std.mem.Allocator) !Snapshot {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const entries = try owned.alloc(Snapshot.Entry, self.entries.count());
    var iterator = self.entries.iterator();
    var index: usize = 0;

    while (iterator.next()) |entry| : (index += 1) {
        const path = try owned.dupe(u8, entry.key_ptr.*);

        const state = switch (entry.value_ptr.state) {
            .directory => |directory| Snapshot.State{ .directory = .{ .digest = directory.digest, .physical_path = try owned.dupe(u8, directory.physical_path) } },
            .file => |file| Snapshot.State{ .file = .{ .digest = file.digest, .physical_path = try owned.dupe(u8, file.physical_path) } },
            else => entry.value_ptr.state,
        };

        entries[index] = .{ .path = path, .state = state };
    }

    std.mem.sort(Snapshot.Entry, entries, {}, lessThan);

    return .{ .arena = arena, .entries = entries, .consistent = self.consistent };
}

pub fn current(self: *const Self, io: std.Io, allocator: std.mem.Allocator) !Snapshot {
    var paths: std.ArrayList([]const u8) = .empty;

    defer paths.deinit(allocator);

    var iterator = self.entries.keyIterator();

    while (iterator.next()) |path| try paths.append(allocator, path.*);

    return Snapshot.capture(io, allocator, paths.items);
}

fn lessThan(_: void, left: Snapshot.Entry, right: Snapshot.Entry) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}
