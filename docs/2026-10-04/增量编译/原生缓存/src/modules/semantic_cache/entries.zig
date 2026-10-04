const std = @import("std");
const Artifact = @import("../artifact/model.zig");
pub const Entry = struct { dirty: bool = true, context_digest: [32]u8, result: Artifact.Result };
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
    const entry = entries.get(path) orelse return null;

    if (!std.mem.eql(u8, &entry.result.value.source_digest, &source_digest) or !std.mem.eql(u8, &entry.context_digest, &context_digest)) return null;

    return &entry.result.value;
}

pub fn put(allocator: std.mem.Allocator, entries: *Map, result: Artifact.Result, context_digest: [32]u8) std.mem.Allocator.Error!void {
    if (entries.get(result.value.path)) |entry| {
        entry.result.deinit();

        entry.* = .{ .context_digest = context_digest, .result = result };

        return;
    }

    const key = try allocator.dupe(u8, result.value.path);

    errdefer allocator.free(key);

    const entry = try allocator.create(Entry);

    errdefer allocator.destroy(entry);

    entry.* = .{ .context_digest = context_digest, .result = result };

    try entries.put(allocator, key, entry);
}
