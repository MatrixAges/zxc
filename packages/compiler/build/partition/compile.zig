const std = @import("std");
const file_manifest = @import("file_manifest.zig");
const cache_key = @import("cache_key.zig");
const state = @import("state.zig");

/// Compiles the partitions of a generated tree into one object each, in a directory kept across builds:
///
///     partition-objects <zig> <generated> <objects> <count> [<input directory>...] -- <build-obj arguments>
///
/// A partition is recompiled only when its digest changes: the content hashes the generator's file manifest lists for
/// its directory, `types.zig` and `signatures.zig`, the build-obj arguments, the Zig executable and every
/// input file or directory. One Zig process per changed partition replaces a cache check per partition. In the arguments,
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
    const zig_stat = try cwd.statFile(init.io, plan.zig, .{});
    var shared: cache_key.Shared = .{};

    shared.init();
    shared.prefix(plan.zig, zig_stat, plan.template, manifest.get("types.zig") orelse return error.MissingGeneratedFile, manifest.get("signatures.zig") orelse return error.MissingGeneratedFile);

    for (args[5..separator]) |path| try shared.input(init.io, allocator, path);

    const digests = try cache_key.partitions(allocator, plan.count, shared.state(), &manifest);
    const keys = try state.Keys.init(allocator, digests);
    const state_path = try std.fs.path.join(allocator, &.{ plan.objects, "state" });

    const previous = cwd.readFileAlloc(init.io, state_path, allocator, .unlimited) catch |err| switch (err) {
        error.FileNotFound => "",
        else => return err,
    };

    try cwd.createDirPath(init.io, plan.objects);

    const present = try allocator.alloc(bool, digests.len);

    for (present, 0..) |*exists, index| {
        const object = try objectPath(allocator, plan.objects, @intCast(index));

        exists.* = if (cwd.access(init.io, object, .{})) true else |_| false;
    }

    const pending = try keys.pending(allocator, previous, present);

    if (pending.len == 0) return;

    // Drop old records before any worker can replace an object. An interrupted build can leave an object without a
    // record, which will be rebuilt even when the inputs return to their previous contents.
    @memset(present, true);

    for (pending) |index| present[index] = false;
    if (previous.len != 0) try keys.write(init.io, allocator, state_path, present);

    const results = try allocator.alloc(?[]const u8, pending.len);
    var work = Work{ .io = init.io, .plan = plan, .pending = pending, .results = results };
    const threads = try allocator.alloc(std.Thread, @min(std.Thread.getCpuCount() catch 1, pending.len) -| 1);
    var started: usize = 0;

    for (threads) |*thread| {
        thread.* = std.Thread.spawn(.{}, Work.run, .{&work}) catch break;
        started += 1;
    }

    work.run();

    for (threads[0..started]) |thread| thread.join();

    var failed = false;

    for (pending, results) |index, result| {
        if (result) |stderr| {
            failed = true;

            try std.Io.File.stderr().writeStreamingAll(init.io, stderr);
        } else {
            present[index] = true;
        }
    }

    try keys.write(init.io, allocator, state_path, present);

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
        var arena = std.heap.ArenaAllocator.init(std.heap.smp_allocator);

        defer arena.deinit();

        const allocator = arena.allocator();
        const argv = try allocator.alloc([]const u8, self.plan.template.len + 1);

        argv[0] = self.plan.zig;

        for (self.plan.template, argv[1..]) |arg, *target| target.* = try substitute(allocator, arg, self.plan, index);

        const result = try std.process.run(allocator, self.io, .{ .argv = argv });

        if (result.term == .exited and result.term.exited == 0) return null;

        return try std.fmt.allocPrint(std.heap.smp_allocator, "partition {d}: Zig terminated with {any}\n{s}", .{ index, result.term, result.stderr });
    }
};

fn substitute(allocator: std.mem.Allocator, arg: []const u8, plan: Plan, index: u32) ![]const u8 {
    const generated = try std.mem.replaceOwned(u8, allocator, arg, "%generated%", plan.generated);
    const objects = try std.mem.replaceOwned(u8, allocator, generated, "%objects%", plan.objects);

    return std.mem.replaceOwned(u8, allocator, objects, "%index%", try std.fmt.allocPrint(allocator, "{d}", .{index}));
}

fn objectPath(allocator: std.mem.Allocator, objects: []const u8, index: u32) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}/zxc_partition_{d}.o", .{ objects, index });
}
