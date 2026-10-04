const std = @import("std");
const application = @import("application");
const initial = @import("initial");
const metadata = @import("metadata");
const Self = @This();
pub const Value = initial.Output;

const Snapshot = struct { format_version: u32, identity: []const u8, schema_version: u32, type_identity: []const u8, revision: u64, value: Value };

arena: *std.heap.ArenaAllocator,
io: std.Io,
directory: std.Io.Dir,
store_0: *Value,
revision: u64 = 0,
pub fn initialize(self: *Self) !void {
    const guard = try self.lock();

    defer guard.close(self.io);

    const snapshot = self.read() catch |err| switch (err) {
        error.FileNotFound => snapshot: {
            const value = try initial.execute(self.arena, {});

            try self.write(0, value);

            break :snapshot self.envelope(0, value);
        },
        else => return err,
    };

    self.store_0.* = snapshot.value;
    self.revision = snapshot.revision;

    try self.sync();
}

pub fn begin(self: *Self, comptime slots: anytype) !void {
    comptime {
        if (slots.len != 1 or slots[0] != 0) @compileError("This concrete example has one Store slot");
    }

    const guard = try self.lock();

    defer guard.close(self.io);

    const snapshot = try self.read();

    self.store_0.* = snapshot.value;
    self.revision = snapshot.revision;

    std.debug.print("begin revision={d}\n", .{self.revision});
}

pub fn commit(self: *Self, changes: application.zx_pending) !void {
    const value = changes.store_0 orelse return;
    const next = try std.math.add(u64, self.revision, 1);
    const guard = try self.lock();

    defer guard.close(self.io);

    const snapshot = try self.read();

    if (snapshot.revision != self.revision) return error.Conflict;
    try self.write(next, value);

    self.store_0.* = value;
    self.revision = next;

    try self.sync();
}

fn lock(self: *Self) !std.Io.File {
    const file = try self.directory.createFile(self.io, metadata.lock_name, .{ .truncate = false });

    errdefer file.close(self.io);

    try file.lock(self.io, .exclusive);

    return file;
}

fn read(self: *Self) !Snapshot {
    const allocator = self.arena.allocator();
    const source = try self.directory.readFileAlloc(self.io, metadata.file_name, allocator, .unlimited);
    const result = try std.json.parseFromSliceLeaky(Snapshot, allocator, source, .{});

    if (result.format_version != 1) return error.InvalidSnapshotFormat;
    if (!std.mem.eql(u8, result.identity, metadata.identity)) return error.StoreIdentityMismatch;
    if (result.schema_version != metadata.schema_version) return error.StoreSchemaMismatch;
    if (!std.mem.eql(u8, result.type_identity, metadata.type_identity)) return error.StoreTypeMismatch;

    return result;
}

fn envelope(_: *Self, revision: u64, value: Value) Snapshot {
    return .{ .format_version = 1, .identity = metadata.identity, .schema_version = metadata.schema_version, .type_identity = metadata.type_identity, .revision = revision, .value = value };
}

fn write(self: *Self, revision: u64, value: Value) !void {
    const source = try std.json.Stringify.valueAlloc(self.arena.allocator(), self.envelope(revision, value), .{});
    var file = try self.directory.createFileAtomic(self.io, metadata.file_name, .{ .replace = true });

    defer file.deinit(self.io);

    try file.file.writeStreamingAll(self.io, source);
    try file.file.sync(self.io);
    try file.replace(self.io);
}

fn sync(self: *Self) !void {
    const file = self.directory.openFile(self.io, ".", .{ .allow_directory = true }) catch return error.StoreDurabilityUnconfirmed;

    defer file.close(self.io);
    file.sync(self.io) catch return error.StoreDurabilityUnconfirmed;
}
