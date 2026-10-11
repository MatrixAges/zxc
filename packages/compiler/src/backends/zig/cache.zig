const std = @import("std");
const Storage = @import("cache/storage.zig");
const Self = @This();
const Entry = struct { key: [32]u8, source: []u8 };
const Memo = @import("genz").zx.function_analysis.Uniqueness.Memo;

allocator: std.mem.Allocator,
entries: std.StringHashMapUnmanaged(Entry) = .empty,
storage: ?Storage = null,
generated: usize = 0,
reused: usize = 0,
loaded: usize = 0,
written: usize = 0,
discarded: usize = 0,
io_errors: usize = 0,
last_io_error: ?anyerror = null,
/// Keeps the uniqueness memo in `memo` across generations instead of reading and writing it for each one; `flushMemo`
/// writes it to storage.
keeps_memo: bool = false,
memo: ?Memo = null,
pub fn init(allocator: std.mem.Allocator) Self {
    return .{ .allocator = allocator };
}

pub fn initPersistent(allocator: std.mem.Allocator, io: std.Io, directory: []const u8, compiler_digest: [32]u8) std.mem.Allocator.Error!Self {
    return .{ .allocator = allocator, .storage = .{ .io = io, .directory = try allocator.dupe(u8, directory), .compiler_digest = compiler_digest } };
}

pub fn deinit(self: *Self) void {
    var iterator = self.entries.iterator();

    while (iterator.next()) |entry| {
        self.allocator.free(entry.key_ptr.*);
        self.allocator.free(entry.value_ptr.source);
    }

    self.entries.deinit(self.allocator);

    if (self.memo) |*memo| memo.deinit();

    if (self.storage) |storage| self.allocator.free(storage.directory);

    self.* = undefined;
}

pub fn get(self: *Self, name: []const u8, key: [32]u8) std.mem.Allocator.Error!?[]const u8 {
    const fetched = try self.fetch(self.allocator, name, key);

    defer if (fetched == .stored) self.allocator.free(fetched.stored);

    return self.record(name, key, fetched);
}

/// What `fetch` found for one unit, before `record` accounts for it.
pub const Fetched = union(enum) { held: []const u8, stored: []u8, absent, invalid, failed: anyerror };

/// Finds a unit's source without changing the cache, so several threads may fetch while none records; a stored
/// source is read into `allocator`.
pub fn fetch(self: *const Self, allocator: std.mem.Allocator, name: []const u8, key: [32]u8) std.mem.Allocator.Error!Fetched {
    if (self.entries.get(name)) |entry| {
        if (std.mem.eql(u8, &entry.key, &key)) return .{ .held = entry.source };
    }

    const storage = self.storage orelse return .absent;

    const source = storage.read(allocator, key) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidCache => return .invalid,
        else => return .{ .failed = err },
    } orelse return .absent;

    return .{ .stored = source };
}

/// Accounts for a fetch and keeps a stored source; returns the source the unit reuses, if any.
pub fn record(self: *Self, name: []const u8, key: [32]u8, fetched: Fetched) std.mem.Allocator.Error!?[]const u8 {
    switch (fetched) {
        .held => |source| {
            self.reused += 1;

            return source;
        },
        .stored => |source| {
            const owned = try self.allocator.dupe(u8, source);

            errdefer self.allocator.free(owned);

            try self.store(name, key, owned);

            self.loaded += 1;
            self.reused += 1;

            return owned;
        },
        .absent => return null,
        .invalid => {
            self.discarded += 1;

            return null;
        },
        .failed => |err| {
            self.recordError(err);

            return null;
        },
    }
}

pub fn put(self: *Self, name: []const u8, key: [32]u8, source: []const u8) std.mem.Allocator.Error!void {
    const owned = try self.allocator.dupe(u8, source);

    self.store(name, key, owned) catch |err| {
        self.allocator.free(owned);

        return err;
    };

    if (self.storage) |storage| {
        const written = storage.write(self.allocator, key, owned) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            self.recordError(err);

            return;
        };

        if (written) self.written += 1;
    }
}

/// Writes the memo this cache keeps to storage, so later generations in other processes reuse it.
pub fn flushMemo(self: *Self) std.mem.Allocator.Error!void {
    if (self.memo) |*memo| try @import("uniqueness_memo.zig").save(self.allocator, self, memo);
}

fn store(self: *Self, name: []const u8, key: [32]u8, source: []u8) std.mem.Allocator.Error!void {
    if (self.entries.getPtr(name)) |entry| {
        self.allocator.free(entry.source);

        entry.* = .{ .key = key, .source = source };

        return;
    }

    const owned_name = try self.allocator.dupe(u8, name);

    errdefer self.allocator.free(owned_name);

    try self.entries.put(self.allocator, owned_name, .{ .key = key, .source = source });
}

fn recordError(self: *Self, err: anyerror) void {
    self.io_errors += 1;
    self.last_io_error = err;
}
