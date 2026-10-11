const std = @import("std");
const parser = @import("../frontend/parse.zig");
const Self = @This();
pub const ModuleResult = parser.ModuleResult;
pub const indexed_enabled = @import("../frontend/module_result.zig").indexed_enabled;

const Entry = struct { digest: [32]u8, result: ModuleResult };

allocator: std.mem.Allocator,
entries: @import("zx").bytes.Map(*Entry) = .empty,
parsed: usize = 0,
reused: usize = 0,
/// Keeps replaced results until `release` instead of freeing them, for analyses that still point into them.
keeps_replaced: bool = false,
replaced: std.ArrayList(ModuleResult) = .empty,
pub fn deinit(self: *Self) void {
    self.release();
    self.replaced.deinit(self.allocator);

    var entries = self.entries.iterator();

    while (entries.next()) |item| {
        item.value_ptr.*.result.deinit();
        self.allocator.destroy(item.value_ptr.*);
        self.allocator.free(item.key_ptr.*);
    }

    self.entries.deinit(self.allocator);

    self.* = undefined;
}

/// Frees the results replaced since the last call.
pub fn release(self: *Self) void {
    for (self.replaced.items) |*result| result.deinit();

    self.replaced.clearRetainingCapacity();
}

/// The digest of the source last parsed for `path`.
pub fn sourceDigest(self: *const Self, path: []const u8) ?[32]u8 {
    const entry = self.entries.get(path) orelse return null;

    return entry.digest;
}

pub fn get(self: *Self, source: []const u8, path: []const u8) std.mem.Allocator.Error!*const parser.Result {
    const entry = try self.getEntry(true, source, path);

    return &entry.result.native;
}

pub fn getModule(self: *Self, source: []const u8, path: []const u8) std.mem.Allocator.Error!*const ModuleResult {
    const entry = try self.getEntry(false, source, path);

    return &entry.result;
}

pub const Request = struct { source: []const u8, path: []const u8 };

/// Parses on all cores the modules `getModule` has no current result for, so a later walk over them only reads. Each
/// result keeps its own arena over the thread-safe page-level allocator, whichever thread parsed it.
pub fn prefetch(self: *Self, requests: []const Request) std.mem.Allocator.Error!void {
    const Prefetch = struct {
        cache: *const Self,
        requests: []const Request,
        digests: [][32]u8,
        results: []?ModuleResult,
        next: std.atomic.Value(usize) = .init(0),
        failed: std.atomic.Value(bool) = .init(false),
        fn run(work: *@This(), _: usize) void {
            while (!work.failed.load(.monotonic)) {
                const index = work.next.fetchAdd(1, .monotonic);

                if (index >= work.requests.len) return;

                const request = work.requests[index];

                std.crypto.hash.sha2.Sha256.hash(request.source, &work.digests[index], .{});

                work.results[index] = null;

                if (work.cache.entries.get(request.path)) |entry| if (std.mem.eql(u8, &entry.digest, &work.digests[index])) continue;

                work.results[index] = parser.parseModule(std.heap.smp_allocator, request.source, request.path) catch {
                    work.failed.store(true, .monotonic);

                    return;
                };
            }
        }
    };

    const digests = try self.allocator.alloc([32]u8, requests.len);

    defer self.allocator.free(digests);

    const results = try self.allocator.alloc(?ModuleResult, requests.len);

    defer self.allocator.free(results);

    @memset(results, null);

    var work = Prefetch{ .cache = self, .requests = requests, .digests = digests, .results = results };

    @import("zx").parallel.spread(Prefetch, &work, Prefetch.run, requests.len);

    var kept: usize = 0;

    errdefer for (results[kept..]) |*result| if (result.*) |*value| value.deinit();

    for (requests, digests, results) |request, digest, *result| {
        const value = result.* orelse {
            kept += 1;

            continue;
        };

        try self.adopt(request.path, digest, value);

        kept += 1;
    }

    if (work.failed.load(.monotonic)) return error.OutOfMemory;
}

fn adopt(self: *Self, path: []const u8, digest: [32]u8, result: ModuleResult) std.mem.Allocator.Error!void {
    if (self.entries.get(path)) |entry| {
        try self.replace(entry.result);

        entry.* = .{ .digest = digest, .result = result };
        self.parsed += 1;

        return;
    }

    const key = try self.allocator.dupe(u8, path);

    errdefer self.allocator.free(key);

    const entry = try self.allocator.create(Entry);

    errdefer self.allocator.destroy(entry);

    entry.* = .{ .digest = digest, .result = result };

    try self.entries.put(self.allocator, key, entry);

    self.parsed += 1;
}

fn replace(self: *Self, result: ModuleResult) std.mem.Allocator.Error!void {
    if (!self.keeps_replaced) {
        var owned = result;

        return owned.deinit();
    }

    try self.replaced.append(self.allocator, result);
}

fn getEntry(self: *Self, comptime native: bool, source: []const u8, path: []const u8) std.mem.Allocator.Error!*Entry {
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(source, &digest, .{});

    if (self.entries.get(path)) |entry| {
        if (std.mem.eql(u8, &entry.digest, &digest)) {
            if (native and entry.result == .indexed) {
                const result = try parser.parse(self.allocator, source, path);

                try self.replace(entry.result);

                entry.result = .{ .native = result };
                self.parsed += 1;
            } else self.reused += 1;

            return entry;
        }

        const result = if (native) ModuleResult{ .native = try parser.parse(self.allocator, source, path) } else try parser.parseModule(self.allocator, source, path);

        try self.replace(entry.result);

        entry.* = .{ .digest = digest, .result = result };
        self.parsed += 1;

        return entry;
    }

    const key = try self.allocator.dupe(u8, path);

    errdefer self.allocator.free(key);

    const entry = try self.allocator.create(Entry);

    errdefer self.allocator.destroy(entry);

    entry.* = .{ .digest = digest, .result = if (native) .{ .native = try parser.parse(self.allocator, source, path) } else try parser.parseModule(self.allocator, source, path) };

    errdefer entry.result.deinit();

    try self.entries.put(self.allocator, key, entry);

    self.parsed += 1;

    return entry;
}
