const std = @import("std");
const rx = @import("rx");

pub fn load(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8, writer: *std.Io.Writer) !?[]const rx.TextSource {
    const project = try @import("../project.zig").load(io, allocator, entry, config_path);

    if (project.diagnostic) |message| {
        try writer.print("{s}\n", .{message});

        return null;
    }

    const root = try std.fs.path.resolve(allocator, &.{project.project.root_dir});
    const cwd = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", allocator);
    const absolute = try std.fs.path.resolve(allocator, &.{ cwd, entry });
    const owner = try std.fs.path.relative(allocator, root, null, root, absolute);
    var loaded = try @import("collection.zig").load(allocator, .{ .io = io, .root = root, .entry = owner, .writer = writer, .project = project.project }) orelse return null;

    defer loaded.deinit();

    for (loaded.data.functions) |function| {
        const path = try std.fs.path.resolve(allocator, &.{ root, function.path });

        if (!try @import("function.zig").validate(io, allocator, path, function.source, config_path, writer)) return null;
    }

    var libraries = @import("../library/inputs.zig"){ .allocator = allocator };

    defer libraries.deinit();

    if (!try @import("compiled.zig").collect(allocator, .{ .io = io, .modules = loaded.data.modules, .project = project.project, .libraries = &libraries, .inputs = null, .writer = writer })) return null;

    const sources = try allocator.alloc(rx.TextSource, loaded.data.sources.len);

    for (loaded.data.sources, sources) |source, *item| {
        item.* = .{ .path = try allocator.dupe(u8, source.path), .source = try allocator.dupe(u8, source.source), .packages = source.packages };
    }

    return sources;
}
