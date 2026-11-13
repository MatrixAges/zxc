const std = @import("std");
const compiler = @import("compiler");
const zx = @import("zx");
const SemanticCache = compiler.project.SemanticCache;
const identity = @import("cache_identity").digest;
const Self = @This();
const Kind = enum { source, native };

io: std.Io,
allocator: std.mem.Allocator,
directory: []const u8,
file_limit: usize,
loaded: usize = 0,
discarded: usize = 0,
written: usize = 0,
native_loaded: usize = 0,
native_written: usize = 0,
pub fn init(io: std.Io, allocator: std.mem.Allocator, root: []const u8) !Self {
    const directory = try std.fs.path.join(allocator, &.{ root, ".zxc", "cache", "semantic", &std.fmt.bytesToHex(identity(), .lower) });

    return .{ .io = io, .allocator = allocator, .directory = directory, .file_limit = SemanticCache.fileLimit() };
}

pub fn deinit(self: *Self) void {
    self.allocator.free(self.directory);

    self.* = undefined;
}

pub fn load(self: *Self, sources: []const compiler.project.Source, project: compiler.project.Options, cache: *SemanticCache) !void {
    var seen: std.StringHashMapUnmanaged(void) = .empty;

    defer seen.deinit(self.allocator);

    for (sources) |source| {
        const path = try std.fs.path.resolve(self.allocator, &.{ project.root_dir, source.path });

        defer self.allocator.free(path);

        if (try self.loadEntry(cache.allocator, &cache.entries, path, .source)) self.loaded += 1;

        const parsed = try cache.parse_cache.getModule(source.source, path);

        if (parsed.diagnostic() != null) continue;

        const imports: ImportLoader = .{ .disk = self, .cache = cache, .seen = &seen };

        switch (parsed.*) {
            .native => |result| try SemanticCache.prefetch(zx.syntax.header.Native{ .program = result.value.parsed.ast }, path, &project, imports),
            .indexed => |*result| if (compiler.project.ParseCache.indexed_enabled) try SemanticCache.prefetch(result.header(), path, &project, imports) else unreachable,
        }
    }
}

const ImportLoader = struct {
    disk: *Self,
    cache: *SemanticCache,
    seen: *std.StringHashMapUnmanaged(void),
    pub fn loadNative(self: @This(), key: []const u8) !void {
        const found = try self.seen.getOrPut(self.disk.allocator, key);

        if (found.found_existing) return;
        if (try self.disk.loadEntry(self.cache.allocator, &self.cache.native.items, key, .native)) self.disk.native_loaded += 1;
    }
};

fn loadEntry(self: *Self, allocator: std.mem.Allocator, entries: *SemanticCache.entry_store.Map, key: []const u8, kind: Kind) !bool {
    const location = try self.filePath(key, kind);

    defer self.allocator.free(location);

    const bytes = std.Io.Dir.cwd().readFileAlloc(self.io, location, self.allocator, .limited(self.file_limit)) catch |err| switch (err) {
        error.FileNotFound => return false,
        error.StreamTooLong => {
            self.discarded += 1;

            return false;
        },
        else => return err,
    };

    defer self.allocator.free(bytes);

    SemanticCache.entry_store.load(allocator, entries, bytes, identity(), key) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        self.discarded += 1;

        return false;
    };

    return true;
}

pub fn save(self: *Self, cache: *SemanticCache) !void {
    try self.saveEntries(&cache.entries, .source);
    try self.saveEntries(&cache.native.items, .native);
}

fn saveEntries(self: *Self, entries: *SemanticCache.entry_store.Map, kind: Kind) !void {
    var iterator = entries.iterator();

    while (iterator.next()) |item| {
        const entry = item.value_ptr.*;

        if (!entry.dirty) continue;

        const location = try self.filePath(item.key_ptr.*, kind);

        defer self.allocator.free(location);

        const bytes = try SemanticCache.codec.encode(self.allocator, entry.result.value, entry.context_digest, identity());

        defer self.allocator.free(bytes);

        if (bytes.len >= self.file_limit) continue;
        try @import("artifacts.zig").write(self.io, location, bytes);

        entry.dirty = false;

        if (kind == .native) self.native_written += 1 else self.written += 1;
    }
}

pub fn report(self: *const Self, cache: *const SemanticCache, writer: *std.Io.Writer) !void {
    try writer.print("zxc cache: analyzed={d} reused={d} loaded={d} written={d} discarded={d} uncacheable={d} native_analyzed={d} native_reused={d} native_loaded={d} native_written={d}\n", .{ cache.analyzed, cache.reused, self.loaded, self.written, self.discarded, cache.uncacheable, cache.native.analyzed, cache.native.reused, self.native_loaded, self.native_written });
}

pub fn finish(self: *Self, cache: *SemanticCache, options: @import("options.zig").Options, writer: *std.Io.Writer) !void {
    if (options.cache) self.save(cache) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        try writer.print("zxc cache write: {s}\n", .{@errorName(err)});
    };

    if (options.cache_stats) {
        if (options.cache) try self.report(cache, writer) else try writer.writeAll("zxc cache: disabled\n");
    }
}

fn filePath(self: *const Self, source: []const u8, kind: Kind) std.mem.Allocator.Error![]u8 {
    return SemanticCache.filePath(self.allocator, self.directory, source, kind == .native);
}
