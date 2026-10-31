const std = @import("std");
const compiler = @import("compiler");
const analysis = @import("rx_analysis");
const zx = @import("zx");
const Collection = @import("collection.zig").Data;

pub fn validate(io: std.Io, allocator: std.mem.Allocator, collection: Collection, functions: []const @import("rx").TextSource, project: compiler.project.Options, writer: *std.Io.Writer) !bool {
    if (collection.stores.len == 0) return true;

    var cache = compiler.project.ParseCache{ .allocator = allocator };

    defer cache.deinit();

    var libraries = @import("../library/inputs.zig"){ .allocator = allocator };

    defer libraries.deinit();

    var sources: std.ArrayList(compiler.project.Source) = .empty;
    var seen: std.StringHashMapUnmanaged(void) = .empty;

    defer seen.deinit(allocator);

    for (functions) |function| {
        var options = project;
        options.entry = try std.fs.path.resolve(allocator, &.{ project.root_dir, function.path });

        const imported = try @import("../sources.zig").readWithLibraries(io, allocator, function.source, options, &cache, null, &libraries);

        for (imported) |source| {
            if ((try seen.getOrPut(allocator, source.path)).found_existing) continue;
            try sources.append(allocator, source);
        }
    }

    var options = project;
    options.compiled_libraries = libraries.libraries.items;

    const roots = try allocator.alloc([]const u8, collection.modules.len);

    for (collection.modules, roots) |module, *root| root.* = module.path;

    var graph = try analysis.project.source_graph.build(allocator, .{ .entry = collection.stores[0].path, .additional_roots = roots, .modules = collection.modules, .stores = collection.stores, .sources = sources.items, .project = options, .parse_cache = &cache });

    defer graph.deinit();

    if (graph.value == .diagnostic) return report(writer, graph.value.diagnostic);

    var entries: std.ArrayList([]const u8) = .empty;

    for (graph.value.graph.order) |index| {
        const source = graph.value.graph.modules[index].source;

        if (source == .zx) try entries.append(allocator, sources.items[source.zx].path);
    }

    var signatures = try compiler.project.analyzeSignaturesWithCache(allocator, sources.items, entries.items, options, &cache);

    defer signatures.deinit();

    if (signatures.value == .diagnostic) {
        const issue = signatures.value.diagnostic;
        const source = if (issue.source_index) |index| sources.items[index] else null;
        const location: zx.source.Location = if (source) |value| zx.source.locate(value.source, issue.span.start) else .{ .line = 1, .column = 1 };

        try writer.print("{s}:{d}:{d}: {t}: {s}\n", .{ if (source) |value| value.path else collection.stores[0].path, location.line, location.column, issue.code, issue.message });

        return false;
    }

    options.context.types = signatures.value.data.types;
    options.context.nominal_types = signatures.value.data.nominal_types;
    options.context.native_modules = signatures.value.data.native_modules;
    const registry = try analysis.store.registry.loadSignatures(allocator, collection.stores, options, signatures.value.data);

    return if (registry == .diagnostic) report(writer, registry.diagnostic) else true;
}

fn report(writer: *std.Io.Writer, issue: anytype) !bool {
    try writer.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

    return false;
}
