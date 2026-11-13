const std = @import("std");
const Artifact = @import("artifact/model.zig");
const ParseCache = @import("parse_cache.zig");
const Self = @This();
pub const entry_store = @import("semantic_cache/entries.zig");
const NativeCache = @import("semantic_cache/native.zig");
pub const codec = @import("semantic_cache/codec.zig");
pub const contextDigest = @import("semantic_cache/fingerprint/context/host.zig").digest;
pub const filePath = @import("semantic_cache/fingerprint/file_key.zig").path;
pub const prefetch = @import("semantic_cache/discovery/host.zig").prefetch;

allocator: std.mem.Allocator,
parse_cache: ParseCache,
entries: entry_store.Map = .empty,
native: NativeCache,
analyzed: usize = 0,
reused: usize = 0,
uncacheable: usize = 0,
pub fn init(allocator: std.mem.Allocator) Self {
    return .{ .allocator = allocator, .parse_cache = .{ .allocator = allocator }, .native = .{ .allocator = allocator } };
}

pub fn deinit(self: *Self) void {
    entry_store.deinit(self.allocator, &self.entries);
    self.native.deinit();
    self.parse_cache.deinit();

    self.* = undefined;
}

pub fn get(self: *const Self, path: []const u8, source_digest: [32]u8, context_digest: [32]u8) ?*const Artifact.Module {
    return entry_store.get(&self.entries, path, source_digest, context_digest);
}

pub fn put(self: *Self, result: Artifact.Result, context_digest: [32]u8) std.mem.Allocator.Error!void {
    return entry_store.put(self.allocator, &self.entries, result, context_digest);
}
