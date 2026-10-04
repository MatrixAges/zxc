const std = @import("std");
const compiler = @import("compiler");
const SemanticCache = compiler.project.SemanticCache;
const identity = @import("cache_identity").digest;
const Self = @This();
const Kind = enum { source, native };

io: std.Io,
allocator: std.mem.Allocator,
directory: []const u8,
loaded: usize = 0,
discarded: usize = 0,
written: usize = 0,
native_loaded: usize = 0,
native_written: usize = 0,
pub fn init(io: std.Io, allocator: std.mem.Allocator, root: []const u8) !Self {
    const directory = try std.fs.path.join(allocator, &.{ root, ".zxc", "cache", "semantic", &std.fmt.bytesToHex(identity, .lower) });

    return .{ .io = io, .allocator = allocator, .directory = directory };
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

        const parsed = try cache.parse_cache.get(source.source, path);

        if (parsed.value == .diagnostic) continue;

        for (parsed.value.parsed.ast.imports) |item| {
            const kind = compiler.project.specifier.classify(item.path) catch continue;

            if (kind == .file or kind == .package) continue;

            const key = registered(item.path, path, project) orelse continue;
            const found = try seen.getOrPut(self.allocator, key);

            if (found.found_existing) continue;
            if (try self.loadEntry(cache.allocator, &cache.native.items, key, .native)) self.native_loaded += 1;
        }
    }
}

fn loadEntry(self: *Self, allocator: std.mem.Allocator, entries: *SemanticCache.entry_store.Map, key: []const u8, kind: Kind) !bool {
    const location = try self.filePath(key, kind);

    defer self.allocator.free(location);

    const bytes = std.Io.Dir.cwd().readFileAlloc(self.io, location, self.allocator, .limited(64 * 1024 * 1024)) catch |err| switch (err) {
        error.FileNotFound => return false,
        error.StreamTooLong => {
            self.discarded += 1;

            return false;
        },
        else => return err,
    };

    defer self.allocator.free(bytes);

    var decoded = SemanticCache.codec.decode(allocator, bytes, identity) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        self.discarded += 1;

        return false;
    };

    if (!std.mem.eql(u8, decoded.result.value.path, key)) {
        decoded.result.deinit();

        self.discarded += 1;

        return false;
    }

    SemanticCache.entry_store.put(allocator, entries, decoded.result, decoded.context_digest) catch |err| {
        decoded.result.deinit();

        return err;
    };

    entries.get(key).?.dirty = false;

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

        const bytes = try SemanticCache.codec.encode(self.allocator, entry.result.value, entry.context_digest, identity);

        defer self.allocator.free(bytes);

        if (bytes.len > 64 * 1024 * 1024) continue;
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
    var digest: [32]u8 = undefined;

    std.crypto.hash.sha2.Sha256.hash(source, &digest, .{});

    return std.fmt.allocPrint(self.allocator, "{s}/{s}{s}.cache", .{ self.directory, if (kind == .native) "native/" else "", std.fmt.bytesToHex(digest, .lower) });
}

fn registered(specifier: []const u8, path: []const u8, project: compiler.project.Options) ?[]const u8 {
    for (compiler.project.standard) |entry| {
        if (std.mem.eql(u8, entry.specifier, specifier)) return entry.specifier;
    }

    for (compiler.project.package_scope.nativeInterfaces(project.package_scopes, path, project.native_interfaces)) |entry| {
        if (std.mem.eql(u8, entry.specifier, specifier)) return entry.key();
    }

    return null;
}
