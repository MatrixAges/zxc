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
const max_parse_batch = 16;

/// Parses on all cores the modules `getModule` has no current result for, so a later walk over them only reads. Each
/// result keeps its own arena over the thread-safe page-level allocator, whichever thread parsed it.
pub fn prefetch(self: *Self, requests: []const Request) std.mem.Allocator.Error!void {
    return self.prefetchInto(requests, null);
}

/// Fills the result for each request in the same order. Paths must be distinct. The views remain valid under
/// the same conditions as `getModule` results.
pub fn prefetchModules(self: *Self, requests: []const Request, modules: []*const ModuleResult) std.mem.Allocator.Error!void {
    std.debug.assert(requests.len == modules.len);

    return self.prefetchInto(requests, modules);
}

fn prefetchInto(self: *Self, requests: []const Request, modules: ?[]*const ModuleResult) std.mem.Allocator.Error!void {
    const parallel = @import("zx").parallel;

    const Prefetch = struct {
        cache: *const Self,
        requests: []const Request,
        results: []?Entry,
        modules: ?[]*const ModuleResult,
        batch_size: usize,
        next: std.atomic.Value(usize) = .init(0),
        failed: std.atomic.Value(bool) = .init(false),
        fn run(work: *@This(), _: usize) void {
            var scratch = @import("zx").Arena.init(std.heap.page_allocator);

            defer scratch.deinit();

            while (!work.failed.load(.monotonic)) {
                const first = work.next.fetchAdd(work.batch_size, .monotonic);

                if (first >= work.requests.len) return;

                const batch = work.requests[first..][0..@min(work.batch_size, work.requests.len - first)];

                for (batch, first..) |request, index| {
                    var digest: [32]u8 = undefined;
                    const found = work.cache.entries.get(request.path);

                    if (lookup(found, request.source, false, &digest) == .Reuse) {
                        if (work.modules) |views| views[index] = &found.?.result;

                        continue;
                    }

                    const result = parser.parseModuleIn(std.heap.smp_allocator, &scratch, request.source, request.path) catch {
                        work.failed.store(true, .monotonic);

                        return;
                    };

                    work.results[index] = .{ .digest = digest, .result = result };
                }
            }
        }
    };

    const results = try self.allocator.alloc(?Entry, requests.len);

    defer self.allocator.free(results);

    @memset(results, null);

    const batch_size = @min(max_parse_batch, @max(1, requests.len / parallel.width()));
    var work = Prefetch{ .cache = self, .requests = requests, .results = results, .modules = modules, .batch_size = batch_size };

    parallel.spread(Prefetch, &work, Prefetch.run, requests.len);

    var kept: usize = 0;

    errdefer for (results[kept..]) |*result| if (result.*) |*value| value.result.deinit();

    for (requests, results, 0..) |request, *result, index| {
        if (result.*) |*value| {
            const entry = try self.adopt(request.path, self.entries.probe(request.path), value);

            if (modules) |views| views[index] = &entry.result;
        }

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
