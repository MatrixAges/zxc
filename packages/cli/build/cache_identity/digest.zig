const std = @import("std");

/// Fingerprints the compiler sources into the identity that names zxc's persistent caches:
///
///     cache-identity <output> (text <value> | file <name> <path> | directory <name> <path>)...
///
/// Files are hashed on every core and folded in argument order, a directory's files by sorted relative path. The
/// output directory receives `digest.zig`, which declares `digest`, and `cache_identity.s`, which defines the
/// `zxc_cache_identity` symbol for a platform link. Running as a build step instead of at configure time keeps an
/// edit from invalidating Zig's configuration cache, which would rerun every build script.
pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);

    if (args.len < 2) return error.MissingArguments;

    var fields: std.ArrayList(Field) = .empty;
    var files: std.ArrayList([]const u8) = .empty;
    var index: usize = 2;

    while (index < args.len) {
        const kind = args[index];

        if (std.mem.eql(u8, kind, "text") and index + 1 < args.len) {
            try fields.append(allocator, .{ .text = args[index + 1] });
            index += 2;

            continue;
        }

        if (index + 2 >= args.len) return error.MissingArguments;

        const name = args[index + 1];
        const path = args[index + 2];

        index += 3;

        if (std.mem.eql(u8, kind, "file")) {
            try fields.append(allocator, .{ .files = .{ .name = name, .first = files.items.len, .relative = &.{path}, .directory = false } });
            try files.append(allocator, path);
        } else if (std.mem.eql(u8, kind, "directory")) {
            const relative = try listed(init.io, allocator, path);

            try fields.append(allocator, .{ .files = .{ .name = name, .first = files.items.len, .relative = relative, .directory = true } });

            for (relative) |entry| try files.append(allocator, try std.fs.path.join(allocator, &.{ path, entry }));
        } else return error.UnknownField;
    }

    const digests = try allocator.alloc([32]u8, files.items.len);
    var work = Work{ .io = init.io, .paths = files.items, .digests = digests };

    try work.spread(allocator);

    if (work.failure) |err| return err;

    var hash = std.crypto.hash.Blake3.init(.{});

    field(&hash, "zxc.semantic.cache.v2");

    for (fields.items) |item| switch (item) {
        .text => |value| field(&hash, value),
        .files => |group| {
            field(&hash, group.name);

            if (group.directory) integer(&hash, group.relative.len);

            for (group.relative, digests[group.first..][0..group.relative.len]) |relative, *digest| {
                if (group.directory) field(&hash, relative);

                hash.update(digest);
            }
        },
    };

    var identity: [32]u8 = undefined;

    hash.final(&identity);
    try emit(init.io, allocator, args[1], identity);
}

const Field = union(enum) {
    text: []const u8,
    files: struct { name: []const u8, first: usize, relative: []const []const u8, directory: bool },
};

/// Hashes the listed files, one per claim, on every core.
const Work = struct {
    io: std.Io,
    paths: []const []const u8,
    digests: [][32]u8,
    next: std.atomic.Value(usize) = .init(0),
    failure: ?anyerror = null,

    fn spread(self: *Work, allocator: std.mem.Allocator) !void {
        const threads = try allocator.alloc(std.Thread, @min(std.Thread.getCpuCount() catch 1, self.paths.len / 32 + 1) -| 1);
        var started: usize = 0;

        for (threads) |*thread| {
            thread.* = std.Thread.spawn(.{}, run, .{self}) catch break;
            started += 1;
        }

        self.run();

        for (threads[0..started]) |thread| thread.join();
    }

    fn run(self: *Work) void {
        var buffer: [64 * 1024]u8 = undefined;

        while (true) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.paths.len) return;

            self.digests[position] = digestOf(self.io, self.paths[position], &buffer) catch |err| {
                self.failure = err;

                return;
            };
        }
    }
};

fn digestOf(io: std.Io, path: []const u8, buffer: []u8) ![32]u8 {
    const file = try std.Io.Dir.cwd().openFile(io, path, .{});

    defer file.close(io);

    var reader = file.reader(io, &.{});
    var hash = std.crypto.hash.Blake3.init(.{});

    while (true) {
        const count = try reader.interface.readSliceShort(buffer);

        if (count == 0) break;

        hash.update(buffer[0..count]);
    }

    var digest: [32]u8 = undefined;

    hash.final(&digest);

    return digest;
}

/// The regular files below `path`, by sorted relative path; anything else is refused, since it could not be hashed.
fn listed(io: std.Io, allocator: std.mem.Allocator, path: []const u8) ![]const []const u8 {
    var directory = try std.Io.Dir.cwd().openDir(io, path, .{ .iterate = true });

    defer directory.close(io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    var relative: std.ArrayList([]const u8) = .empty;

    while (try walker.next(io)) |entry| switch (entry.kind) {
        .directory => {},
        .file => try relative.append(allocator, try allocator.dupe(u8, entry.path)),
        else => return error.UnsupportedSourceFile,
    };

    std.mem.sort([]const u8, relative.items, {}, lessThan);

    return relative.items;
}

/// Writes the identity's two forms, leaving files that already hold them untouched.
fn emit(io: std.Io, allocator: std.mem.Allocator, output: []const u8, identity: [32]u8) !void {
    var bytes: std.Io.Writer.Allocating = .init(allocator);

    for (identity, 0..) |byte, index| try bytes.writer.print("{s}{d}", .{ if (index == 0) "" else ", ", byte });

    const listing = bytes.written();
    const directory = try std.Io.Dir.cwd().createDirPathOpen(io, output, .{});

    defer directory.close(io);

    try update(io, allocator, directory, "digest.zig", try std.fmt.allocPrint(allocator, "pub const digest: [32]u8 = .{{ {s} }};\n", .{listing}));
    try update(io, allocator, directory, "cache_identity.s", try std.fmt.allocPrint(allocator, ".section __TEXT,__const\n.globl _zxc_cache_identity\n_zxc_cache_identity:\n.byte {s}\n", .{listing}));
}

fn update(io: std.Io, allocator: std.mem.Allocator, directory: std.Io.Dir, name: []const u8, content: []const u8) !void {
    const current = directory.readFileAlloc(io, name, allocator, .limited(4096)) catch null;

    if (current) |value| if (std.mem.eql(u8, value, content)) return;

    try directory.writeFile(io, .{ .sub_path = name, .data = content });
}

fn field(hash: *std.crypto.hash.Blake3, bytes: []const u8) void {
    integer(hash, bytes.len);
    hash.update(bytes);
}

fn integer(hash: *std.crypto.hash.Blake3, value: u64) void {
    var bytes: [8]u8 = undefined;

    std.mem.writeInt(u64, &bytes, value, .little);
    hash.update(&bytes);
}

fn lessThan(_: void, left: []const u8, right: []const u8) bool {
    return std.mem.lessThan(u8, left, right);
}
