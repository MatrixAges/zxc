const std = @import("std");
const compiler = @import("compiler");
const source = compiler.input_snapshot;
const collection = @import("source_collection.zig");
const manifest = @import("generation_manifest.zig");
const Files = @import("resident/files.zig");
const Self = @This();
const name = "input-snapshots";
const checksum_length = std.crypto.hash.Blake3.digest_length * 2;
const maximum_snapshot_bytes = 8 << 20;
const Root = struct { path: []const u8, entries: []const collection.Entry };
const Fact = struct { path: []const u8, key: []const u8, metadata: Files.Metadata };

roots: []const Root,
facts: []const Fact,
context: []const u8,
path: []const u8,
previous: ?*const source.Snapshot,
stored_checksum: []const u8 = "",
actual_checksum: []const u8 = "",
/// Platform observations only: RX/ZX decides whether the previous snapshot vouches for these files.
pub fn prepare(io: std.Io, allocator: std.mem.Allocator, paths: std.mem.Allocator, files: *Files, digest: [32]u8, project: manifest.Project, text: []const u8, partitions: u32, cache: []const u8) !?Self {
    const roots = try allocator.alloc(Root, project.roots.len);
    var facts: std.ArrayList(Fact) = .empty;

    for (project.roots, roots) |root, *target| {
        const entries = try collection.scan(io, allocator, paths, files, root.path, root.prefix, true);

        target.* = .{ .path = root.path, .entries = entries };

        for (entries) |entry| try facts.append(allocator, .{ .path = try std.fs.path.resolve(allocator, &.{ root.path, entry.relative }), .key = entry.path, .metadata = entry.metadata.? });
    }

    for (project.interfaces) |interface| {
        const fact: Fact = found: {
            for (roots) |root| for (root.entries) |entry| {
                if (entry.zx and std.mem.eql(u8, interface.path, entry.path)) break :found .{ .path = try std.fs.path.resolve(allocator, &.{ root.path, entry.relative }), .key = entry.path, .metadata = entry.metadata.? };
            };

            const path = try std.fs.path.resolve(allocator, &.{interface.path});
            const stat = std.Io.Dir.cwd().statFile(io, interface.path, .{}) catch return .{ .roots = roots, .facts = &.{}, .context = "", .path = "", .previous = null };

            break :found .{ .path = path, .key = path, .metadata = Files.metadata(stat) };
        };

        try facts.append(allocator, fact);
    }

    std.mem.sort(Fact, facts.items, {}, struct {
        fn less(_: void, left: Fact, right: Fact) bool {
            return std.mem.lessThan(u8, left.path, right.path);
        }
    }.less);

    var hash = compiler.Sha256.init(.{});
    const here = try std.process.currentPathAlloc(io, allocator);

    hash.update(&digest);
    hash.update(std.mem.asBytes(&partitions));
    hash.update(std.mem.asBytes(&here.len));
    hash.update(here);
    hash.update(text);

    const context = try allocator.dupe(u8, &std.fmt.bytesToHex(hash.finalResult(), .lower));
    const path = try std.fs.path.join(allocator, &.{ cache, name, context });
    var stored_checksum: []const u8 = "";
    var actual_checksum: []const u8 = "";

    const previous: ?*const source.Snapshot = previous: {
        const recorded = std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(maximum_snapshot_bytes)) catch break :previous null;

        if (recorded.len < checksum_length) break :previous null;

        const payload = recorded[checksum_length..];
        const value = std.json.parseFromSliceLeaky(source.Snapshot, allocator, payload, .{}) catch break :previous null;
        const owned = try allocator.create(source.Snapshot);
        var checksum: [std.crypto.hash.Blake3.digest_length]u8 = undefined;

        std.crypto.hash.Blake3.hash(payload, &checksum, .{});

        owned.* = value;
        stored_checksum = recorded[0..checksum_length];
        actual_checksum = try allocator.dupe(u8, &std.fmt.bytesToHex(checksum, .lower));

        break :previous owned;
    };

    return .{ .roots = roots, .facts = facts.items, .context = context, .path = path, .previous = previous, .stored_checksum = stored_checksum, .actual_checksum = actual_checksum };
}

pub fn current(self: Self, io: std.Io, allocator: std.mem.Allocator) !?[32]u8 {
    const previous = self.previous orelse return null;
    const current_files = try columns(allocator, self.facts, null);
    const now: u96 = @bitCast(std.Io.Timestamp.now(io, .real).nanoseconds);

    if (!try source.reuse(allocator, .{ .context = self.context, .current = &current_files, .previous = previous, .now_high = @bitCast(@as(u32, @truncate(now >> 64))), .now_low = @truncate(now), .stored_checksum = self.stored_checksum, .actual_checksum = self.actual_checksum })) return null;

    var digest: [32]u8 = undefined;

    _ = std.fmt.hexToBytes(&digest, previous.fingerprint) catch return null;

    return digest;
}

pub fn load(self: Self, io: std.Io, allocator: std.mem.Allocator, files: *Files, sources: *std.ArrayList(compiler.project.Source), modules: *std.ArrayList(@import("rx").TextSource), templates: *std.ArrayList(compiler.project.Resource)) !void {
    for (self.roots) |root| try collection.load(io, allocator, files, root.path, root.entries, sources, modules, templates);
}

pub fn save(self: Self, io: std.Io, allocator: std.mem.Allocator, files: *const Files, fingerprint: [32]u8) !void {
    if (self.facts.len == 0) return;
    for (self.facts) |fact| if (files.version(fact.key) == null) return;

    const contents = try columns(allocator, self.facts, files);
    const snapshot: source.Snapshot = .{ .context = self.context, .fingerprint = &std.fmt.bytesToHex(fingerprint, .lower), .files = &contents };
    const bytes = try std.json.Stringify.valueAlloc(allocator, snapshot, .{});

    if (bytes.len > maximum_snapshot_bytes - checksum_length) return;

    var checksum: [std.crypto.hash.Blake3.digest_length]u8 = undefined;

    std.crypto.hash.Blake3.hash(bytes, &checksum, .{});

    try std.Io.Dir.cwd().createDirPath(io, std.fs.path.dirname(self.path).?);

    const file = try std.Io.Dir.cwd().createFile(io, self.path, .{});

    defer file.close(io);

    try file.writeStreamingAll(io, &std.fmt.bytesToHex(checksum, .lower));
    try file.writeStreamingAll(io, bytes);
}

fn columns(allocator: std.mem.Allocator, facts: []const Fact, files: ?*const Files) !source.Files {
    var result: source.Files = undefined;

    inline for (@typeInfo(source.Files).@"struct".field_names) |field| {
        const Child = std.meta.Child(@FieldType(source.Files, field));

        @field(result, field) = try allocator.alloc(Child, if (files == null and std.mem.startsWith(u8, field, "read_")) 0 else facts.len);
    }

    for (facts, 0..) |fact, index| {
        const version = if (files) |cache| cache.version(fact.key) else null;
        const metadata = if (version) |value| value.metadata else fact.metadata;

        @constCast(result.paths)[index] = fact.path;
        @constCast(result.inodes)[index] = metadata.inode;
        @constCast(result.sizes)[index] = metadata.size;
        timestamp(&result, "mtime", index, metadata.mtime);
        timestamp(&result, "ctime", index, metadata.ctime);
        if (version) |value| timestamp(&result, "read", index, value.read);
    }

    return result;
}

fn timestamp(columns_value: *source.Files, comptime field: []const u8, index: usize, value: i96) void {
    const bits: u96 = @bitCast(value);

    @constCast(@field(columns_value, field ++ "_low"))[index] = @truncate(bits);
    @constCast(@field(columns_value, field ++ "_high"))[index] = @bitCast(@as(u32, @truncate(bits >> 64)));
}
