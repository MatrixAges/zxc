const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const Files = @import("resident/files.zig");
const listing = @import("directory_listing.zig");
const Reader = listing.Reader;

pub fn lessSource(_: void, left: compiler.project.Source, right: compiler.project.Source) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}

pub fn lessModule(_: void, left: rx.TextSource, right: rx.TextSource) bool {
    return std.mem.lessThan(u8, left.path, right.path);
}

/// Appends the ZX and RX sources under `root`, named with `prefix`; `files`, when given, owns their texts. The tree is
/// listed one depth at a time, every directory of a depth on its own core, and a listed file whose metadata vouches for
/// the text `files` kept takes that text there; the calling thread reads the others afterwards.
pub fn collect(io: std.Io, allocator: std.mem.Allocator, files: ?*Files, root: []const u8, prefix: []const u8, sources: *std.ArrayList(compiler.project.Source), modules: *std.ArrayList(rx.TextSource)) !void {
    var directory = try std.Io.Dir.cwd().openDir(io, root, .{});

    defer directory.close(io);

    const arenas = try allocator.alloc(std.heap.ArenaAllocator, compiler.parallel.width());

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    defer for (arenas) |*arena| arena.deinit();

    var level: std.ArrayList([]const u8) = .empty;

    try level.append(allocator, "");

    while (level.items.len != 0) {
        var work = List{ .io = io, .root = directory, .prefix = prefix, .files = files, .directories = level.items, .listings = try allocator.alloc(anyerror!Listing, level.items.len), .arenas = arenas };

        compiler.parallel.spread(List, &work, List.run, level.items.len);

        var next: std.ArrayList([]const u8) = .empty;

        for (level.items, work.listings) |parent, result| {
            const found = try result;

            for (found.directories) |name| try next.append(allocator, try join(allocator, parent, name));

            for (found.files) |file| {
                const relative = try join(allocator, parent, file.name);
                const path = try std.mem.concat(allocator, u8, &.{ prefix, relative });
                const source = file.text orelse if (files) |kept| try kept.read(io, directory, relative, path) else try directory.readFileAlloc(io, relative, allocator, .unlimited);

                if (file.zx) try sources.append(allocator, .{ .path = path, .source = source }) else try modules.append(allocator, .{ .path = path, .source = source });
            }
        }

        level = next;
    }
}

const File = struct { name: []const u8, zx: bool, text: ?[]const u8 };
const Listing = struct { files: []const File, directories: []const []const u8 };

/// The directories of one depth, listed by every participant taking the next one left.
const List = struct {
    io: std.Io,
    root: std.Io.Dir,
    prefix: []const u8,
    files: ?*const Files,
    directories: []const []const u8,
    listings: []anyerror!Listing,
    arenas: []std.heap.ArenaAllocator,
    next: std.atomic.Value(usize) = .init(0),
    fn run(work: *List, participant: usize) void {
        const arena = work.arenas[participant].allocator();

        while (true) {
            const index = work.next.fetchAdd(1, .monotonic);

            if (index >= work.directories.len) return;

            work.listings[index] = work.list(arena, work.directories[index]);
        }
    }
    fn list(work: *const List, arena: std.mem.Allocator, parent: []const u8) !Listing {
        var directory = try work.root.openDir(work.io, if (parent.len == 0) "." else parent, .{ .iterate = true });

        defer directory.close(work.io);

        var files: std.ArrayList(File) = .empty;
        var directories: std.ArrayList([]const u8) = .empty;
        var entries = Reader.init(directory);

        while (try entries.next(work.io)) |entry| switch (entry.kind) {
            .directory => try directories.append(arena, try arena.dupe(u8, entry.name)),
            .file => {
                const zx = std.mem.endsWith(u8, entry.name, ".zx");

                if (!zx and !std.mem.endsWith(u8, entry.name, ".rx")) continue;
                try files.append(arena, .{ .name = try arena.dupe(u8, entry.name), .zx = zx, .text = try work.kept(directory, parent, entry) });
            },
            else => {},
        };

        return .{ .files = files.items, .directories = directories.items };
    }

    /// The text `files` kept for `entry` of `parent`, if its metadata still vouches for it.
    fn kept(work: *const List, directory: std.Io.Dir, parent: []const u8, entry: listing.Entry) !?[]const u8 {
        const files = work.files orelse return null;
        var buffer: [std.fs.max_path_bytes]u8 = undefined;
        const key = std.fmt.bufPrint(&buffer, "{s}{s}{s}{s}", .{ work.prefix, parent, if (parent.len == 0) "" else "/", entry.name }) catch return null;

        return files.unchanged(work.io, directory, entry.name, key, entry.metadata);
    }
};

fn join(allocator: std.mem.Allocator, parent: []const u8, name: []const u8) ![]const u8 {
    return if (parent.len == 0) allocator.dupe(u8, name) else std.mem.concat(allocator, u8, &.{ parent, "/", name });
}
