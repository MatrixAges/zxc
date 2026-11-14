const std = @import("std");
const Artifact = @import("../artifact/model.zig");
const State = @import("state/host.zig");
const codec = @import("codec.zig");

pub const Entry = struct {
    dirty: bool = true,
    decoded: bool = false,
    native_admitted: bool = false,
    context_digest: [32]u8,
    result: Artifact.Result,
};

pub const Map = @import("../source_index/growing.zig").Map(*Entry);

pub fn deinit(allocator: std.mem.Allocator, entries: *Map) void {
    for (entries.keys.items, entries.values.items) |key, entry| {
        entry.result.deinit();
        allocator.destroy(entry);
        allocator.free(key);
    }

    entries.deinit(allocator);
}

pub fn get(entries: *const Map, path: []const u8, source_digest: [32]u8, context_digest: [32]u8) ?*const Artifact.Module {
    const entry = find(entries, path, &source_digest, &context_digest) orelse return null;

    return &entry.result.value;
}

pub fn find(entries: *const Map, path: []const u8, source_digest: *const [32]u8, context_digest: *const [32]u8) ?*Entry {
    const entry = entries.get(path) orelse return null;

    if (!State.version(&entry.result.value.source_digest, source_digest, &entry.context_digest, context_digest)) return null;

    return entry;
}

pub fn put(allocator: std.mem.Allocator, entries: *Map, result: Artifact.Result, context_digest: [32]u8) std.mem.Allocator.Error!void {
    try install(allocator, entries, .{ .result = result, .context_digest = context_digest });
}

pub fn load(allocator: std.mem.Allocator, entries: *Map, bytes: []const u8, compiler_digest: [32]u8, expected: []const u8) codec.Error!void {
    var decoded = try codec.decodeForPath(allocator, bytes, compiler_digest, expected);

    errdefer decoded.result.deinit();

    try install(allocator, entries, .{
        .dirty = false,
        .decoded = true,
        .result = decoded.result,
        .context_digest = decoded.context_digest,
    });
}

pub const Publication = struct {
    entry: *Entry,
    key: ?[]const u8,
    slot: usize = 0,
    pub fn cancel(self: Publication, allocator: std.mem.Allocator) void {
        if (self.key) |key| {
            allocator.free(key);
            allocator.destroy(self.entry);
        }
    }

    pub fn commit(self: Publication, entries: *Map, value: Entry) void {
        if (self.key) |key| {
            entries.append(self.slot, key, self.entry);
        } else {
            self.entry.result.deinit();
        }

        self.entry.* = value;
    }
};

pub fn prepare(allocator: std.mem.Allocator, entries: *Map, path: []const u8) std.mem.Allocator.Error!Publication {
    var selected = entries.probe(path);

    if (selected.existing) |entry| return .{ .entry = entry, .key = null };
    if (try entries.reserve(allocator)) selected = entries.probe(path);

    const key = try allocator.dupe(u8, path);

    errdefer allocator.free(key);

    return .{ .entry = try allocator.create(Entry), .key = key, .slot = selected.position };
}

fn install(allocator: std.mem.Allocator, entries: *Map, value: Entry) std.mem.Allocator.Error!void {
    const publication = try prepare(allocator, entries, value.result.value.path);

    publication.commit(entries, value);
}
