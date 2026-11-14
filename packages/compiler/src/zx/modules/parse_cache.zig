const std = @import("std");
const parser = @import("../frontend/parse.zig");
const probe = @import("parse_cache/probe.zig");
const Index = @import("source_index/growing.zig").Map(*Entry);
const Self = @This();
pub const ModuleResult = parser.ModuleResult;
pub const indexed_enabled = @import("../frontend/module_result.zig").indexed_enabled;

const Entry = struct { digest: [32]u8, result: ModuleResult };

allocator: std.mem.Allocator,
entries: Index = .empty,
parsed: usize = 0,
reused: usize = 0,
/// Keeps replaced results until `release` instead of freeing them, for analyses that still point into them.
keeps_replaced: bool = false,
replaced: std.ArrayList(ModuleResult) = .empty,
pub fn deinit(self: *Self) void {
    self.release();
    self.replaced.deinit(self.allocator);

    for (self.entries.keys.items, self.entries.values.items) |key, entry| {
        entry.result.deinit();
        self.allocator.destroy(entry);
        self.allocator.free(key);
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

pub const Version = struct { result: *const ModuleResult, digest: [32]u8 };

pub fn getModuleVersion(self: *Self, source: []const u8, path: []const u8) std.mem.Allocator.Error!Version {
    const entry = try self.getEntry(false, source, path);

    return .{ .result = &entry.result, .digest = entry.digest };
}

pub const Request = struct { source: []const u8, path: []const u8 };

/// Parses on all cores the modules `getModule` has no current result for, so a later walk over them only reads. Each
/// result keeps its own arena over the thread-safe page-level allocator, whichever thread parsed it.
pub fn prefetch(self: *Self, requests: []const Request) std.mem.Allocator.Error!void {
    const Prefetch = struct {
        cache: *const Self,
        requests: []const Request,
        results: []?Entry,
        next: std.atomic.Value(usize) = .init(0),
        failed: std.atomic.Value(bool) = .init(false),
        fn run(work: *@This(), _: usize) void {
            var scratch = @import("zx").Arena.init(std.heap.page_allocator);

            defer scratch.deinit();

            while (!work.failed.load(.monotonic)) {
                const index = work.next.fetchAdd(1, .monotonic);

                if (index >= work.requests.len) return;

                const request = work.requests[index];
                var digest: [32]u8 = undefined;

                if (lookup(work.cache.entries.get(request.path), request.source, false, &digest) == .Reuse) continue;

                const result = parser.parseModuleIn(std.heap.smp_allocator, &scratch, request.source, request.path) catch {
                    work.failed.store(true, .monotonic);

                    return;
                };

                work.results[index] = .{ .digest = digest, .result = result };
            }
        }
    };

    const results = try self.allocator.alloc(?Entry, requests.len);

    defer self.allocator.free(results);

    @memset(results, null);

    var work = Prefetch{ .cache = self, .requests = requests, .results = results };

    @import("zx").parallel.spread(Prefetch, &work, Prefetch.run, requests.len);

    var kept: usize = 0;

    errdefer for (results[kept..]) |*result| if (result.*) |*value| value.result.deinit();

    for (requests, results) |request, *result| {
        if (result.*) |*value| _ = try self.adopt(request.path, self.entries.probe(request.path), value);

        kept += 1;
    }

    if (work.failed.load(.monotonic)) return error.OutOfMemory;
}

fn adopt(self: *Self, path: []const u8, found: Index.Slot, value: *const Entry) std.mem.Allocator.Error!*Entry {
    if (found.existing) |entry| {
        try self.replace(entry.result);

        entry.* = value.*;
        self.parsed += 1;

        return entry;
    }

    const slot = if (try self.entries.reserve(self.allocator)) self.entries.probe(path).position else found.position;
    const key = try self.allocator.dupe(u8, path);

    errdefer self.allocator.free(key);

    const entry = try self.allocator.create(Entry);

    errdefer self.allocator.destroy(entry);

    entry.* = value.*;

    self.entries.append(slot, key, entry);

    self.parsed += 1;

    return entry;
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
    const found = self.entries.probe(path);

    switch (lookup(found.existing, source, native, &digest)) {
        .Reuse => {
            self.reused += 1;

            return found.existing.?;
        },
        .Upgrade => digest = found.existing.?.digest,
        .Parse => {},
    }

    var prepared: Entry = .{
        .digest = digest,
        .result = if (native) .{ .native = try parser.parse(self.allocator, source, path) } else try parser.parseModule(self.allocator, source, path),
    };

    errdefer prepared.result.deinit();

    return self.adopt(path, found, &prepared);
}

fn lookup(entry: ?*const Entry, source: []const u8, native: bool, digest: *[32]u8) probe.Action {
    const kept = entry orelse return probe.run(source, null, null, native, false, digest);

    return probe.run(source, kept.result.text(), &kept.digest, native, kept.result == .indexed, digest);
}
