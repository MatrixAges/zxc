//! What a generator keeps between requests: the parsed modules, the generation cache with the sources it has read,
//! the last analysis with everything it points into, and its own identity. A one-shot run starts from an empty
//! state; a resident generator keeps one for its lifetime.
const std = @import("std");
const compiler = @import("compiler");
const History = @import("rx_analysis").project.History;
const Files = @import("files.zig");
const Modules = @import("modules.zig");
const Self = @This();
/// Past this much retained memory the next analysis starts over, so the memory it no longer needs is freed. Each
/// analysis that reuses modules keeps the ones before it, a little over 100 MB for the compiler itself, so this allows
/// about two dozen such edits between full analyses while staying well inside the memory budget.
const retained_limit = 3 << 30;

gpa: std.mem.Allocator,
/// The generator's executable digest, which names its outputs and cache records.
digest: [32]u8,
parse_cache: compiler.project.ParseCache,
/// The sources read so far, so unchanged ones keep their texts.
files: Files,
modules: Modules,
generation: ?Generation = null,
history: History = .{ .frame = @splat(0) },
/// The analyses and request inputs the last analysis may point into: every one since the last analysis that reused
/// nothing.
epochs: std.ArrayList(std.heap.ArenaAllocator) = .empty,
/// The current request's inputs, when the caller reads them through `requestAllocator`.
request: ?std.heap.ArenaAllocator = null,
/// Whether the current request's inputs join `epochs` when it ends.
keeps_request: bool = false,
/// Memory the current request no longer needs, freed once it ends so that freeing it does not hold up the answer.
discarded: ?std.heap.ArenaAllocator = null,
/// What each request's output is built in, reset rather than freed between requests so that its pages stay mapped:
/// copying the reused sources into fresh pages costs more in page faults than in copying.
emission: std.heap.ArenaAllocator,
const Generation = struct { path: []u8, cache: compiler.zig.GenerationCache };

pub fn init(io: std.Io, gpa: std.mem.Allocator) !Self {
    var scratch = std.heap.ArenaAllocator.init(gpa);

    defer scratch.deinit();

    return .{ .gpa = gpa, .digest = try @import("../generator_digest.zig").create(io, scratch.allocator()), .parse_cache = .{ .allocator = gpa, .keeps_replaced = true }, .files = .{ .gpa = gpa }, .modules = .{ .gpa = gpa }, .emission = .init(gpa) };
}

pub fn deinit(self: *Self) void {
    if (self.generation) |*generation| {
        generation.cache.deinit();
        self.gpa.free(generation.path);
    }

    self.endRequest();
    self.release();
    self.epochs.deinit(self.gpa);
    self.emission.deinit();
    self.parse_cache.deinit();
    self.files.deinit();
    self.modules.deinit();
}

/// The generation cache persisted under `path`, kept across requests that name the same directory.
pub fn generationCache(self: *Self, io: std.Io, path: []const u8) !*compiler.zig.GenerationCache {
    if (self.generation) |*generation| {
        if (std.mem.eql(u8, generation.path, path)) return &generation.cache;

        generation.cache.deinit();
        self.gpa.free(generation.path);

        self.generation = null;
    }

    const owned = try self.gpa.dupe(u8, path);

    errdefer self.gpa.free(owned);

    self.generation = .{ .path = owned, .cache = try compiler.zig.GenerationCache.initPersistent(self.gpa, io, path, self.digest) };
    self.generation.?.cache.keeps_memo = true;

    return &self.generation.?.cache;
}

/// Writes what later processes reuse from this one to the cache directory.
pub fn persist(self: *Self) void {
    if (self.generation) |*generation| {
        generation.cache.flush();
        generation.cache.flushMemo() catch {};
    }
}

/// An arena for one request's inputs; it is kept when the analysis of that request is.
pub fn requestAllocator(self: *Self) std.mem.Allocator {
    self.endRequest();

    self.request = .init(self.gpa);

    return self.request.?.allocator();
}

/// The allocator the current request's output is built in; what the previous request built there must be discarded.
pub fn emissionAllocator(self: *Self) std.mem.Allocator {
    _ = self.emission.reset(.retain_capacity);

    return self.emission.allocator();
}

/// Frees `arena` once the current request ends; it must hold nothing the request still reads.
pub fn discard(self: *Self, arena: std.heap.ArenaAllocator) void {
    var owned = arena;

    if (self.discarded != null) return owned.deinit();

    self.discarded = owned;
}

/// Ends the current request; its arena allocator must no longer be used.
pub fn endRequest(self: *Self) void {
    if (self.discarded) |*arena| arena.deinit();

    self.discarded = null;

    if (self.request) |*request| {
        if (self.keeps_request) self.epochs.appendAssumeCapacity(request.*) else request.deinit();
    }

    self.request = null;
    self.keeps_request = false;
}

/// The history for an analysis of inputs identified by `frame`, whose RX sources have `rx_digests` within `shape`.
pub fn startAnalysis(self: *Self, frame: [32]u8, shape: [32]u8, rx_digests: []const @import("rx_analysis").project.ModuleDigest) *History {
    self.history.frame = frame;
    self.history.shape = shape;
    self.history.rx_digests = rx_digests;
    self.history.next = null;
    self.history.reused = 0;
    self.history.analyzed = 0;
    self.history.bodies_only = false;
    self.history.signatures_reused = false;

    if (self.retained() > retained_limit) self.history.previous = null;

    return &self.history;
}

/// Keeps the analysis that just succeeded, whose memory is `analysis`, for the next request.
pub fn keepAnalysis(self: *Self, analysis: std.heap.ArenaAllocator) std.mem.Allocator.Error!void {
    var owned = analysis;

    errdefer owned.deinit();

    // An analysis that reused neither modules nor the earlier frame points into nothing older.
    if (self.history.reused == 0 and !self.history.bodies_only and !self.history.signatures_reused) self.release();
    try self.epochs.ensureUnusedCapacity(self.gpa, 2);

    self.history.previous = self.history.next;
    self.history.next = null;

    self.epochs.appendAssumeCapacity(owned);

    self.keeps_request = self.request != null;
}

fn release(self: *Self) void {
    for (self.epochs.items) |*epoch| epoch.deinit();

    self.epochs.clearRetainingCapacity();

    self.history.previous = null;

    self.parse_cache.release();
    self.files.release();
    self.modules.release();
}

fn retained(self: *const Self) usize {
    var total: usize = 0;

    for (self.epochs.items) |*epoch| total += epoch.queryCapacity();

    return total;
}
