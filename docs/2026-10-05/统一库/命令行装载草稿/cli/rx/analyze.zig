const std = @import("std");
const compiler = @import("compiler");
const analysis = @import("rx_analysis");
const collection = @import("collection.zig");
const Inputs = @import("../watch/inputs.zig");
pub const Result = struct { analysis: compiler.AnalysisResult, sources: []const compiler.project.Source, store_definitions: []const analysis.store.Definition };

pub const Options = struct {
    io: std.Io,
    project: compiler.project.Options,
    writer: *std.Io.Writer,
    inputs: ?*Inputs = null,
};

pub fn run(allocator: std.mem.Allocator, options: Options) !?Result {
    const io = options.io;
    var project = options.project;
    const root = try std.fs.path.resolve(allocator, &.{project.root_dir});
    const owner = try std.fs.path.relative(allocator, root, null, root, project.entry);

    if (collection.outside(owner)) return error.RxEntryOutsideProject;

    var loaded = try collection.load(allocator, .{ .io = io, .root = root, .entry = owner, .writer = options.writer, .inputs = options.inputs, .check_initializers = false }) orelse return null;

    defer loaded.deinit();

    for (loaded.data.modules) |module| {
        try validatePath(allocator, options, try std.fs.path.resolve(allocator, &.{ root, module.path }));
    }

    var cache = compiler.project.ParseCache{ .allocator = allocator };

    defer cache.deinit();

    var libraries = @import("../library/inputs.zig"){ .allocator = allocator };

    defer libraries.deinit();

    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var seen: std.StringHashMapUnmanaged(void) = .empty;

    defer seen.deinit(allocator);

    for (loaded.data.functions) |function| {
        const path = try std.fs.path.resolve(allocator, &.{ root, function.path });

        try validatePath(allocator, options, path);
        if (seen.contains(path)) continue;

        var function_project = project;
        function_project.entry = path;

        const text = try allocator.dupe(u8, function.source);
        const imported = try @import("../sources.zig").readWithLibraries(io, allocator, text, function_project, &cache, options.inputs, &libraries);

        for (imported) |item| {
            if (project.package_scopes.len == 0) try validatePath(allocator, options, item.path);
            if ((try seen.getOrPut(allocator, item.path)).found_existing) continue;
            try sources.append(allocator, item);
        }
    }

    project.compiled_libraries = libraries.libraries.items;

    var inferred = try analysis.project.infer(allocator, .{ .entry = owner, .modules = loaded.data.modules, .stores = loaded.data.stores, .sources = sources.items, .project = project });

    errdefer inferred.deinit();

    if (inferred.value == .diagnostic) {
        const issue = inferred.value.diagnostic;

        try options.writer.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        inferred.deinit();

        return null;
    }

    const contract = inferred.value.contract;

    for (loaded.data.sources) |source| {
        try sources.append(allocator, .{
            .path = try std.fs.path.resolve(allocator, &.{ root, source.path }),
            .source = try allocator.dupe(u8, source.source),
        });
    }

    return .{ .analysis = .{ .arena = inferred.arena, .value = .{ .ir = contract.program }, .nominal_types = contract.nominal_types }, .sources = sources.items, .store_definitions = contract.store_definitions };
}

fn validatePath(allocator: std.mem.Allocator, options: Options, path: []const u8) !void {
    if (options.inputs) |inputs| try inputs.add(options.io, path);

    const root = try std.Io.Dir.cwd().realPathFileAlloc(options.io, options.project.root_dir, allocator);
    const real = try std.Io.Dir.cwd().realPathFileAlloc(options.io, path, allocator);
    const relative = try std.fs.path.relative(allocator, root, null, root, real);

    if (collection.outside(relative)) return error.RxSourceOutsideProject;
    try @import("../../package/source.zig").validateWithInputs(options.io, allocator, path, options.project.package_scopes, options.inputs);
}
