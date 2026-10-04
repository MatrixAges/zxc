const std = @import("std");
const Object = @import("../state.zig").Object;

pub fn write(writer: *std.Io.Writer, object: Object, index: usize) std.Io.Writer.Error!void {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(object.identity, &digest, .{});

    try writer.print(
        \\fn initialize_{0d}(self: *Self) !void {{
        \\    self.store_{0d} = &self.value_{0d};
        \\    const guard = try self.lock_{0d}();
        \\    defer guard.close(self.io);
        \\
        \\    const snapshot = self.read_{0d}() catch |err| switch (err) {{
        \\        error.FileNotFound => missing: {{
        \\            const value = try initial_{0d}.execute(self.arena, {{}});
        \\            try self.write_{0d}(0, value);
        \\            try self.sync();
        \\            break :missing self.envelope_{0d}(0, value);
        \\        }},
        \\        else => return err,
        \\    }};
        \\
        \\    self.value_{0d} = snapshot.value;
        \\    self.revision_{0d} = snapshot.revision;
        \\}}
        \\
        \\fn commit_{0d}(self: *Self, value: initial_{0d}.Output) !void {{
        \\    const next = try std.math.add(u64, self.revision_{0d}, 1);
        \\    const guard = try self.lock_{0d}();
        \\    defer guard.close(self.io);
        \\
        \\    const snapshot = try self.read_{0d}();
        \\    if (snapshot.revision != self.revision_{0d}) return error.Conflict;
        \\    try self.write_{0d}(next, value);
        \\
        \\    self.value_{0d} = value;
        \\    self.revision_{0d} = next;
        \\    try self.sync();
        \\}}
        \\
        \\fn lock_{0d}(self: *Self) !std.Io.File {{
        \\    const file = try self.directory.createFile(self.io, "{1s}.lock", .{{ .truncate = false }});
        \\    errdefer file.close(self.io);
        \\    try file.lock(self.io, .exclusive);
        \\    return file;
        \\}}
        \\
        \\fn read_{0d}(self: *Self) !Snapshot_{0d} {{
        \\    const allocator = self.arena.allocator();
        \\    const source = try self.directory.readFileAlloc(self.io, "{1s}.json", allocator, .unlimited);
        \\    const snapshot = try std.json.parseFromSliceLeaky(Snapshot_{0d}, allocator, source, .{{}});
        \\
        \\    if (snapshot.format_version != 1) return error.InvalidSnapshotFormat;
        \\    if (!std.mem.eql(u8, snapshot.identity, "{2f}")) return error.StoreIdentityMismatch;
        \\    if (snapshot.schema_version != {3d}) return error.StoreSchemaMismatch;
        \\    if (!std.mem.eql(u8, snapshot.type_identity, "{4f}")) return error.StoreTypeMismatch;
        \\    return snapshot;
        \\}}
        \\
        \\fn envelope_{0d}(_: *Self, revision: u64, value: initial_{0d}.Output) Snapshot_{0d} {{
        \\    return .{{ .format_version = 1, .identity = "{2f}", .schema_version = {3d}, .type_identity = "{4f}", .revision = revision, .value = value }};
        \\}}
        \\
        \\fn write_{0d}(self: *Self, revision: u64, value: initial_{0d}.Output) !void {{
        \\    const source = try std.json.Stringify.valueAlloc(self.arena.allocator(), self.envelope_{0d}(revision, value), .{{}});
        \\    if (!try std.json.validate(self.arena.allocator(), source)) return error.InvalidStoreEncoding;
        \\    var file = try self.directory.createFileAtomic(self.io, "{1s}.json", .{{ .replace = true }});
        \\    defer file.deinit(self.io);
        \\
        \\    try file.file.writeStreamingAll(self.io, source);
        \\    try file.file.sync(self.io);
        \\    try file.replace(self.io);
        \\}}
        \\
        \\
    , .{ index, std.fmt.bytesToHex(digest, .lower), std.zig.fmtString(object.identity), object.schema_version, std.zig.fmtString(object.type_name) });
}
