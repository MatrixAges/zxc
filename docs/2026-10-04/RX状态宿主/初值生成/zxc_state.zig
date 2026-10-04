const std = @import("std");
const application = @import("application");
const Self = @This();
const initial_0 = @import("zxc_store_initial_48e225adb6047085dc9c57a6bbf984093fd90a4db7884bb3477c633a6862f720");
const Snapshot_0 = struct { format_version: u32, identity: []const u8, schema_version: u32, type_identity: []const u8, revision: u64, value: initial_0.Output };

arena: *std.heap.ArenaAllocator,
io: std.Io,
directory: std.Io.Dir,
value_0: initial_0.Output = undefined,
store_0: *initial_0.Output = undefined,
revision_0: u64 = 0,
pub fn initialize(self: *Self) !void {
    try self.initialize_0();
}

pub fn begin(self: *Self, comptime slots: anytype) !void {
    comptime { for (slots) |slot| { if (slot >= 1) @compileError("Invalid Store slot"); } }

    const guard_0: ?std.Io.File = if (comptime std.mem.indexOfScalar(u32, &slots, 0) != null) try self.lock_0() else null;

    defer if (guard_0) |file| file.close(self.io);

    const next_0: ?Snapshot_0 = if (comptime std.mem.indexOfScalar(u32, &slots, 0) != null) try self.read_0() else null;

    if (next_0) |snapshot| { self.value_0 = snapshot.value; self.revision_0 = snapshot.revision; }
}

pub fn commit(self: *Self, changes: application.zx_pending) !void {
    var count: usize = 0;

    if (changes.store_0 != null) count += 1;
    if (count > 1) return error.MultipleStoreObjects;
    if (changes.store_0) |value| try self.commit_0(value);
}

fn sync(self: *Self) !void {
    const file = self.directory.openFile(self.io, ".", .{ .allow_directory = true }) catch return error.StoreDurabilityUnconfirmed;

    defer file.close(self.io);
    file.sync(self.io) catch return error.StoreDurabilityUnconfirmed;
}

fn initialize_0(self: *Self) !void {
    self.store_0 = &self.value_0;

    const guard = try self.lock_0();

    defer guard.close(self.io);

    const snapshot = self.read_0() catch |err| switch (err) {
        error.FileNotFound => missing: {
            const value = try initial_0.execute(self.arena, {});

            try self.write_0(0, value);
            try self.sync();

            break :missing self.envelope_0(0, value);
        },
        else => return err,
    };

    self.value_0 = snapshot.value;
    self.revision_0 = snapshot.revision;
}

fn commit_0(self: *Self, value: initial_0.Output) !void {
    const next = try std.math.add(u64, self.revision_0, 1);
    const guard = try self.lock_0();

    defer guard.close(self.io);

    const snapshot = try self.read_0();

    if (snapshot.revision != self.revision_0) return error.Conflict;
    try self.write_0(next, value);

    self.value_0 = value;
    self.revision_0 = next;

    try self.sync();
}

fn lock_0(self: *Self) !std.Io.File {
    const file = try self.directory.createFile(self.io, "48e225adb6047085dc9c57a6bbf984093fd90a4db7884bb3477c633a6862f720.lock", .{ .truncate = false });

    errdefer file.close(self.io);

    try file.lock(self.io, .exclusive);

    return file;
}

fn read_0(self: *Self) !Snapshot_0 {
    const allocator = self.arena.allocator();
    const source = try self.directory.readFileAlloc(self.io, "48e225adb6047085dc9c57a6bbf984093fd90a4db7884bb3477c633a6862f720.json", allocator, .unlimited);
    const snapshot = try std.json.parseFromSliceLeaky(Snapshot_0, allocator, source, .{});

    if (snapshot.format_version != 1) return error.InvalidSnapshotFormat;
    if (!std.mem.eql(u8, snapshot.identity, "store.state.store.rx:counter")) return error.StoreIdentityMismatch;
    if (snapshot.schema_version != 1) return error.StoreSchemaMismatch;
    if (!std.mem.eql(u8, snapshot.type_identity, "zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75")) return error.StoreTypeMismatch;

    return snapshot;
}

fn envelope_0(_: *Self, revision: u64, value: initial_0.Output) Snapshot_0 {
    return .{ .format_version = 1, .identity = "store.state.store.rx:counter", .schema_version = 1, .type_identity = "zx_type_9c0956fc19fc5a12ae17fc217785b3c644f316bf3bd238db16ec80a1afed5c75", .revision = revision, .value = value };
}

fn write_0(self: *Self, revision: u64, value: initial_0.Output) !void {
    const source = try std.json.Stringify.valueAlloc(self.arena.allocator(), self.envelope_0(revision, value), .{});

    if (!try std.json.validate(self.arena.allocator(), source)) return error.InvalidStoreEncoding;

    var file = try self.directory.createFileAtomic(self.io, "48e225adb6047085dc9c57a6bbf984093fd90a4db7884bb3477c633a6862f720.json", .{ .replace = true });

    defer file.deinit(self.io);

    try file.file.writeStreamingAll(self.io, source);
    try file.file.sync(self.io);
    try file.replace(self.io);
}
