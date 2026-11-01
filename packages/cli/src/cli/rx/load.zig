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

    const functions = try @import("type_sources.zig").collect(allocator, .{
        .io = io,
        .project = project.project,
        .modules = loaded.data.modules,
        .stores = loaded.data.stores,
        .functions = loaded.data.functions,
        .writer = writer,
    }) orelse return null;

    const graph_entry = if (loaded.data.gateway != null)
        if (loaded.data.modules.len != 0) loaded.data.modules[0].path else null

    else
        owner;

    if (graph_entry) |selected| {
        const zx_sources = try allocator.alloc(@import("compiler").project.Source, functions.len);
        const roots = try allocator.alloc([]const u8, loaded.data.modules.len);

        for (functions, zx_sources) |function, *source| source.* = .{ .path = function.path, .source = function.source };
        for (loaded.data.modules, roots) |module, *path| path.* = module.path;

        var graph = try @import("rx_analysis").project.source_graph.build(allocator, .{
            .entry = selected,
            .additional_roots = roots,
            .sources = zx_sources,
            .modules = loaded.data.modules,
            .stores = loaded.data.stores,
            .project = project.project,
        });

        defer graph.deinit();

        if (graph.value == .diagnostic) {
            const issue = graph.value.diagnostic;

            try writer.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

            return null;
        }
    }

    if (!try @import("store_types.zig").validate(io, allocator, loaded.data, functions, project.project, writer)) return null;

    for (functions) |function| {
        const path = try std.fs.path.resolve(allocator, &.{ root, function.path });

        if (!try @import("function.zig").validate(io, allocator, path, function.source, config_path, loaded.data.modules, writer)) return null;
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
