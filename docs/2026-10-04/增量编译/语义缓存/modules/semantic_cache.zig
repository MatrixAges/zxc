const std = @import("std");
const Artifact = @import("artifact/model.zig");
const ParseCache = @import("parse_cache.zig");
const Context = @import("../analysis/analyze.zig").Context;
const Self = @This();
const Entry = struct { context_digest: [32]u8, result: Artifact.Result };

allocator: std.mem.Allocator,
parse_cache: ParseCache,
entries: std.StringHashMapUnmanaged(*Entry) = .empty,
analyzed: usize = 0,
reused: usize = 0,
uncacheable: usize = 0,
pub fn init(allocator: std.mem.Allocator) Self {
    return .{ .allocator = allocator, .parse_cache = .{ .allocator = allocator } };
}

pub fn deinit(self: *Self) void {
    var entries = self.entries.iterator();

    while (entries.next()) |entry| {
        entry.value_ptr.*.result.deinit();
        self.allocator.destroy(entry.value_ptr.*);
        self.allocator.free(entry.key_ptr.*);
    }

    self.entries.deinit(self.allocator);
    self.parse_cache.deinit();

    self.* = undefined;
}

pub fn get(self: *const Self, path: []const u8, source_digest: [32]u8, context_digest: [32]u8) ?*const Artifact.Module {
    const entry = self.entries.get(path) orelse return null;

    if (!std.mem.eql(u8, &entry.result.value.source_digest, &source_digest) or !std.mem.eql(u8, &entry.context_digest, &context_digest)) return null;

    return &entry.result.value;
}

pub fn put(self: *Self, result: Artifact.Result, context_digest: [32]u8) std.mem.Allocator.Error!void {
    if (self.entries.get(result.value.path)) |entry| {
        entry.result.deinit();

        entry.* = .{ .context_digest = context_digest, .result = result };

        return;
    }

    const key = try self.allocator.dupe(u8, result.value.path);

    errdefer self.allocator.free(key);

    const entry = try self.allocator.create(Entry);

    errdefer self.allocator.destroy(entry);

    entry.* = .{ .context_digest = context_digest, .result = result };

    try self.entries.put(self.allocator, key, entry);
}

pub fn contextDigest(allocator: std.mem.Allocator, context: Context) std.mem.Allocator.Error![32]u8 {
    const encoded = try std.json.Stringify.valueAlloc(allocator, context, .{});

    defer allocator.free(encoded);

    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(encoded, &digest, .{});

    return digest;
}
