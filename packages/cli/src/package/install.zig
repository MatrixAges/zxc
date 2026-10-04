const std = @import("std");
const pkgs = @import("pkgs");
const Options = @import("install/options.zig");
const model = @import("install/model.zig");
const files = @import("install/files.zig");
pub const usage = Options.usage;

pub fn run(io: std.Io, allocator: std.mem.Allocator, args: []const []const u8, environment: *const std.process.Environ.Map, output: *std.Io.Writer, errors: *std.Io.Writer) !bool {
    const options = Options.parse(args) catch {
        try errors.writeAll(usage);

        return false;
    };

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const count = install(io, arena.allocator(), options, environment) catch |err| {
        if (err == error.OutOfMemory) return err;

        try errors.print("{s}: install: {s}\n", .{ options.path, @errorName(err) });

        return false;
    };

    try output.print("Installed {d} packages; pkg.lock.json is up to date.\n", .{count});

    return true;
}

fn install(io: std.Io, allocator: std.mem.Allocator, options: Options, environment: *const std.process.Environ.Map) !usize {
    const root = try std.Io.Dir.cwd().realPathFileAlloc(io, std.fs.path.dirname(options.path) orelse ".", allocator);
    const discovered = try @import("workspace.zig").load(io, allocator, options.path);

    if (discovered.diagnostic != null) return error.InvalidWorkspace;

    const cache = try @import("../cli/toolchain/cache.zig").root(allocator, environment);
    const previous = try files.load(io, allocator, root, null);
    const reuse = previous != null and model.matchesWorkspace(previous.?.lock, discovered.packages);

    var prepared = if (reuse)
        try @import("install/replay.zig").prepare(io, allocator, previous.?.lock, root, cache, options.offline)

    else fresh: {
        if (options.frozen) return if (previous == null) error.LockFileMissing else error.LockFileOutdated;

        const source = if (options.index) |path|
            try std.Io.Dir.cwd().readFileAlloc(io, path, allocator, .limited(16 * 1024 * 1024))

        else
            @import("bundle").index;

        const parsed = try pkgs.Index.parse(allocator, source);
        const base = try std.Io.Dir.cwd().realPathFileAlloc(io, if (options.index) |path| std.fs.path.dirname(path) orelse "." else ".", allocator);

        break :fresh try @import("install/resolve.zig").resolve(io, allocator, discovered.packages, parsed.value, .{ .root = root, .cache = cache, .source_base = base, .offline = options.offline });
    };

    if (reuse) prepared.source = previous.?.source;

    const current = try @import("workspace.zig").load(io, allocator, options.path);

    if (current.diagnostic != null or !model.matchesWorkspace(prepared.lock, current.packages)) return error.WorkspaceChangedDuringInstall;
    try files.publish(io, allocator, root, prepared);

    return prepared.lock.packages.len;
}
