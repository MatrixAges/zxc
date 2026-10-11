const std = @import("std");
const file_manifest = @import("file_manifest.zig");

/// Compiles the partitions of a generated tree into one object each, in a directory kept across builds:
///
///     partition-objects <zig> <generated> <objects> <count> [<input directory>...] -- <build-obj arguments>
///
/// A partition is recompiled only when its digest changes: the content hashes the generator's file manifest lists for
/// its directory, `types.zig` and `bridge.zig`, the build-obj arguments, the Zig executable and the contents of every
/// input directory. One Zig process per changed partition replaces a cache check per partition. In the arguments,
/// `%generated%`, `%objects%` and `%index%` stand for the tree, the object directory and the partition number.
pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const args = try init.minimal.args.toSlice(allocator);
    const separator = for (args, 0..) |arg, index| {
        if (std.mem.eql(u8, arg, "--")) break index;
    } else return error.MissingArguments;

    if (separator < 5) return error.MissingArguments;

    const plan = Plan{
        .zig = args[1],
        .generated = args[2],
        .objects = args[3],
        .count = try std.fmt.parseInt(u32, args[4], 10),
        .template = args[separator + 1 ..],
    };

    const cwd = std.Io.Dir.cwd();
    const manifest = try file_manifest.parse(allocator, try cwd.readFileAlloc(init.io, try std.fs.path.join(allocator, &.{ plan.generated, file_manifest.name }), allocator, .unlimited));
    var shared = std.crypto.hash.Blake3.init(.{});

    field(&shared, "zxc.partition.objects.v1");
    field(&shared, plan.zig);

    const zig_stat = try cwd.statFile(init.io, plan.zig, .{});

    integer(&shared, @intCast(zig_stat.size));
    integer(&shared, @bitCast(@as(i64, @truncate(zig_stat.mtime.nanoseconds))));

    for (plan.template) |arg| field(&shared, arg);
    for ([_][]const u8{ "types.zig", "bridge.zig" }) |path| integer(&shared, manifest.get(path) orelse return error.MissingGeneratedFile);
    for (args[5..separator]) |directory| try contents(init.io, allocator, &shared, directory);

    const digests = try partitionDigests(allocator, plan.count, shared, &manifest);
    const state_path = try std.fs.path.join(allocator, &.{ plan.objects, "state" });
    const previous = cwd.readFileAlloc(init.io, state_path, allocator, .unlimited) catch |err| switch (err) {
        error.FileNotFound => "",
        else => return err,
    };

    try cwd.createDirPath(init.io, plan.objects);

    var pending: std.ArrayList(u32) = .empty;

    for (digests, 0..) |digest, index| {
        const object = try objectPath(allocator, plan.objects, @intCast(index));
        const present = if (cwd.access(init.io, object, .{})) true else |_| false;

        if (!present or !recorded(previous, @intCast(index), digest)) try pending.append(allocator, @intCast(index));
    }

    const results = try allocator.alloc(?[]const u8, pending.items.len);
    var work = Work{ .io = init.io, .plan = plan, .pending = pending.items, .results = results };
    const threads = try allocator.alloc(std.Thread, @min(std.Thread.getCpuCount() catch 1, pending.items.len) -| 1);
    var started: usize = 0;

    for (threads) |*thread| {
        thread.* = std.Thread.spawn(.{}, Work.run, .{&work}) catch break;
        started += 1;
    }

    work.run();

    for (threads[0..started]) |thread| thread.join();

    var failed = false;
    var state: std.Io.Writer.Allocating = .init(allocator);

    for (results) |result| if (result) |stderr| {
        failed = true;

        try std.Io.File.stderr().writeStreamingAll(init.io, stderr);
    };

    // A failed partition keeps no digest, so the next build compiles it again.
    for (digests, 0..) |digest, index| {
        const position = std.mem.indexOfScalar(u32, pending.items, @intCast(index));

        if (position) |at| if (results[at] != null) continue;
        if (position == null and !recorded(previous, @intCast(index), digest)) continue;

        try state.writer.print("{d} {s}\n", .{ index, std.fmt.bytesToHex(digest, .lower) });
    }

    try cwd.writeFile(init.io, .{ .sub_path = state_path, .data = state.written() });

    if (failed) return error.PartitionCompileFailed;
}

const Plan = struct {
    zig: []const u8,
    generated: []const u8,
    objects: []const u8,
    count: u32,
    template: []const []const u8,
};

/// Compiles the pending partitions; a result holds the compiler's output when it failed.
const Work = struct {
    io: std.Io,
    plan: Plan,
    pending: []const u32,
    results: []?[]const u8,
    next: std.atomic.Value(usize) = .init(0),

    fn run(self: *Work) void {
        while (true) {
            const position = self.next.fetchAdd(1, .monotonic);

            if (position >= self.pending.len) return;

            self.results[position] = self.compile(self.pending[position]) catch |err| @errorName(err);
        }
    }

    fn compile(self: *Work, index: u32) !?[]const u8 {
        const allocator = std.heap.smp_allocator;
        const argv = try allocator.alloc([]const u8, self.plan.template.len + 1);

        argv[0] = self.plan.zig;

        for (self.plan.template, argv[1..]) |arg, *target| target.* = try substitute(allocator, arg, self.plan, index);

        const result = try std.process.run(allocator, self.io, .{ .argv = argv });

        return switch (result.term) {
            .exited => |code| if (code == 0) null else result.stderr,
            else => result.stderr,
        };
    }
};

fn substitute(allocator: std.mem.Allocator, arg: []const u8, plan: Plan, index: u32) ![]const u8 {
    const generated = try std.mem.replaceOwned(u8, allocator, arg, "%generated%", plan.generated);
    const objects = try std.mem.replaceOwned(u8, allocator, generated, "%objects%", plan.objects);

    return std.mem.replaceOwned(u8, allocator, objects, "%index%", try std.fmt.allocPrint(allocator, "{d}", .{index}));
}

fn partitionDigests(allocator: std.mem.Allocator, count: u32, shared: std.crypto.hash.Blake3, manifest: *const std.StringHashMapUnmanaged(u64)) ![][32]u8 {
    const members = try allocator.alloc(std.ArrayList([]const u8), count);

    @memset(members, .empty);

    var paths = manifest.keyIterator();

    while (paths.next()) |path| {
        if (!std.mem.startsWith(u8, path.*, "part_")) continue;

        const slash = std.mem.indexOfScalar(u8, path.*, '/') orelse continue;
        const index = std.fmt.parseInt(u32, path.*["part_".len..slash], 10) catch continue;

        if (index < count) try members[index].append(allocator, path.*);
    }

    const digests = try allocator.alloc([32]u8, count);

    for (members, digests) |*paths_of, *digest| {
        std.mem.sort([]const u8, paths_of.items, {}, lessThan);

        var hash = shared;

        for (paths_of.items) |path| {
            field(&hash, path);
            integer(&hash, manifest.get(path).?);
        }

        hash.final(digest);
    }

    return digests;
}

fn recorded(state: []const u8, index: u32, digest: [32]u8) bool {
    var lines = std.mem.splitScalar(u8, state, '\n');
    var prefix: [16]u8 = undefined;
    const head = std.fmt.bufPrint(&prefix, "{d} ", .{index}) catch unreachable;

    while (lines.next()) |line| {
        if (std.mem.startsWith(u8, line, head)) return std.mem.eql(u8, line[head.len..], &std.fmt.bytesToHex(digest, .lower));
    }

    return false;
}

fn objectPath(allocator: std.mem.Allocator, objects: []const u8, index: u32) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}/zxc_partition_{d}.o", .{ objects, index });
}

/// Feeds every file below `path` to `hash`, by sorted relative path.
fn contents(io: std.Io, allocator: std.mem.Allocator, hash: *std.crypto.hash.Blake3, path: []const u8) !void {
    var directory = try std.Io.Dir.cwd().openDir(io, path, .{ .iterate = true });

    defer directory.close(io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    var files: std.ArrayList([]const u8) = .empty;

    while (try walker.next(io)) |entry| if (entry.kind == .file) try files.append(allocator, try allocator.dupe(u8, entry.path));

    std.mem.sort([]const u8, files.items, {}, lessThan);
    field(hash, path);

    for (files.items) |file| {
        field(hash, file);
        field(hash, try directory.readFileAlloc(io, file, allocator, .unlimited));
    }
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
