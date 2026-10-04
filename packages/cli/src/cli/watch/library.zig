const std = @import("std");
const compiler = @import("compiler");
const Inputs = @import("inputs.zig");
const Options = @import("../options.zig").Options;
const Loaded = @import("../project.zig").Loaded;

pub fn run(io: std.Io, allocator: std.mem.Allocator, bundle: compiler.zig.ModuleBundle, sources: []const compiler.project.Source, options: Options, loaded: Loaded, cache: *compiler.project.ParseCache, inputs: *Inputs) !bool {
    var random: [16]u8 = undefined;

    std.Io.random(io, &random);

    const name = std.fmt.bytesToHex(random, .lower);
    const staging = try std.fs.path.resolve(allocator, &.{ inputs.cwd, ".zxc", "build", "watch", &name });

    try std.Io.Dir.cwd().createDirPath(io, staging);

    defer std.Io.Dir.cwd().deleteTree(io, staging) catch {};

    var staged_options = options;

    staged_options.output = staging;

    try @import("../library.zig").runWithInputs(io, allocator, bundle, sources, staged_options, loaded, cache, inputs);

    const destination = try std.fs.path.resolve(allocator, &.{ inputs.cwd, options.output.? });
    var observed = try inputs.observed(allocator);

    defer observed.deinit();

    for (observed.entries) |entry| {
        const relative = try std.fs.path.relative(allocator, destination, null, destination, entry.path);

        if (!std.fs.path.isAbsolute(relative) and !std.mem.eql(u8, relative, "..") and !std.mem.startsWith(u8, relative, ".." ++ std.fs.path.sep_str)) return error.OutputOverlapsInput;
    }

    var current = try inputs.current(io, allocator);

    defer current.deinit();

    if (!observed.same(current)) return false;

    var directory = try std.Io.Dir.openDirAbsolute(io, staging, .{ .iterate = true });

    defer directory.close(io);

    var walker = try directory.walk(allocator);

    defer walker.deinit();

    var paths: std.ArrayList([]const u8) = .empty;

    while (try walker.next(io)) |entry| {
        if (entry.kind != .file) continue;

        const target = try std.fs.path.join(allocator, &.{ destination, entry.path });
        const physical = try @import("output.zig").check(io, allocator, inputs, target);

        allocator.free(physical);

        try paths.append(allocator, try allocator.dupe(u8, entry.path));
    }

    for (paths.items) |path| {
        const target = try std.fs.path.join(allocator, &.{ destination, path });

        try directory.copyFile(path, .cwd(), target, io, .{ .make_path = true });
    }

    return true;
}
