const std = @import("std");
const Artifact = @import("../artifact/model.zig");
const State = @import("state/host.zig");
const codec = @import("codec.zig");

pub const Entry = struct {
    dirty: bool = true,
    decoded: bool = false,
    context_digest: [32]u8,
    result: Artifact.Result,
};

pub const Map = std.StringHashMapUnmanaged(*Entry);

pub fn deinit(allocator: std.mem.Allocator, entries: *Map) void {
    var iterator = entries.iterator();

    while (iterator.next()) |entry| {
        entry.value_ptr.*.result.deinit();
        allocator.destroy(entry.value_ptr.*);
        allocator.free(entry.key_ptr.*);
    }

    entries.deinit(allocator);
}

pub fn get(entries: *const Map, path: []const u8, source_digest: [32]u8, context_digest: [32]u8) ?*const Artifact.Module {
    const entry = find(entries, path, source_digest, context_digest) orelse return null;

    return &entry.result.value;
}

pub fn find(entries: *const Map, path: []const u8, source_digest: [32]u8, context_digest: [32]u8) ?*const Entry {
    const entry = entries.get(path) orelse return null;

    if (!State.version(&entry.result.value.source_digest, &source_digest, &entry.context_digest, &context_digest)) return null;

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

fn install(allocator: std.mem.Allocator, entries: *Map, value: Entry) std.mem.Allocator.Error!void {
    const path = value.result.value.path;

    if (entries.get(path)) |entry| {
        entry.result.deinit();

        entry.* = value;

        return;
    }

    const key = try allocator.dupe(u8, path);

    errdefer allocator.free(key);

    const entry = try allocator.create(Entry);

    errdefer allocator.destroy(entry);

    entry.* = value;

    try entries.put(allocator, key, entry);
}
