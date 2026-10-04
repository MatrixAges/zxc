const std = @import("std");
const rx = @import("rx");

pub fn load(io: std.Io, allocator: std.mem.Allocator, entry: []const u8, config_path: ?[]const u8, writer: *std.Io.Writer) !?[]const rx.TextSource {
    var loaded = try @import("collection.zig").load(allocator, .{ .io = io, .root = ".", .entry = entry, .writer = writer }) orelse return null;

    defer loaded.deinit();

    for (loaded.data.functions) |function| {
        if (!try @import("function.zig").validate(io, allocator, function.path, function.source, config_path, writer)) return null;
    }

    const compiled = @import("compiled.zig");

    const needs_libraries = for (loaded.data.modules) |module| {
        if (compiled.hasReference(module.node)) break true;
    } else false;

    if (needs_libraries) {
        var project = try @import("../project.zig").load(io, allocator, entry, config_path);

        if (project.diagnostic) |message| {
            try writer.print("{s}\n", .{message});

            return null;
        }

        project.project.root_dir = try std.Io.Dir.cwd().realPathFileAlloc(io, ".", allocator);

        var libraries = @import("../library/inputs.zig"){ .allocator = allocator };

        defer libraries.deinit();

        if (!try @import("compiled.zig").collect(allocator, .{ .io = io, .modules = loaded.data.modules, .project = project.project, .libraries = &libraries, .inputs = null, .writer = writer })) return null;
    }

    const sources = try allocator.alloc(rx.TextSource, loaded.data.sources.len);

    for (loaded.data.sources, sources) |source, *item| {
        item.* = .{ .path = try allocator.dupe(u8, source.path), .source = try allocator.dupe(u8, source.source) };
    }

    return sources;
}
