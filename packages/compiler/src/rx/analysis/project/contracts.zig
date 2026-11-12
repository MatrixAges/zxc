const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const Graph = @import("../inference/types.zig");
const Prepared = @import("prepare.zig");
const SourceMap = @import("../source_map.zig");
const Source = @import("contracts/source.zig");
pub const Port = struct { module: usize, kind: Source.Kind, type_id: zx.ir.TypeId };

pub fn resolve(graph: *Graph, modules: []const Prepared.Module, source_map: SourceMap) zx.Error![]const Port {
    var source = Source{ .allocator = graph.allocator };

    try source.collect(modules);

    const owners = source.entries.items(.module);

    if (owners.len == 0) return &.{};

    var parsed = try frontend.parseModule(graph.allocator, source.text, modules[@intCast(owners[0])].source.path);

    defer parsed.deinit();

    if (parsed.diagnostic()) |issue| return fail(graph, source, source_map, issue);

    switch (parsed) {
        .native => |native| {
            const program = native.value.parsed.ast;

            if (program.imports.len != 0 or program.constants.len != 0 or program.body != null or program.contracts.len != 0 or program.has_store) return invalid(graph, source, source_map);

            return resolveDeclarations(graph, modules, source, source_map, frontend.type_views.Native{ .items = program.declarations });
        },
        .indexed => |indexed| if (comptime @TypeOf(indexed) != void) {
            const output = indexed.output;

            if (output.imports.len != 0 or output.constants.len != 0 or output.body != null or output.contracts.len != 0 or output.has_store) return invalid(graph, source, source_map);

            return resolveDeclarations(graph, modules, source, source_map, frontend.type_views.Indexed(@TypeOf(output)){ .source = indexed.source, .storage = output });
        } else unreachable,
    }
}

fn resolveDeclarations(graph: *Graph, modules: []const Prepared.Module, source: Source, source_map: SourceMap, view: anytype) zx.Error![]const Port {
    if (!source.valid(view)) return invalid(graph, source, source_map);

    const storage = if (comptime @hasField(@TypeOf(view), "storage")) .{ .types = view.storage.types, .type_order = view.storage.type_order } else .{};

    const resolving = if (comptime @hasField(@TypeOf(view), "storage"))
        frontend.type_views.Indexed(@TypeOf(storage)){ .source = view.source, .storage = storage }

    else
        frontend.type_views.Native{ .items = &.{} };

    const previous_reporter = graph.types.reporter;
    const previous_aliases = graph.types.aliases;
    var reporter: zx.Reporter = .{};
    graph.types.reporter = &reporter;

    defer {
        graph.types.reporter = previous_reporter;
        graph.types.aliases = previous_aliases;
    }

    const owners = source.entries.items(.module);
    const ports = try graph.allocator.alloc(Port, owners.len);
    var declarations = view.declarations().iterator();
    var start: usize = 0;

    while (start < owners.len) {
        const owner: usize = @intCast(owners[start]);
        var end = start + 1;

        while (end < owners.len and owners[end] == owner) : (end += 1) {}

        graph.types.aliases = modules[owner].type_imports;

        for (ports[start..end], start..) |*port, index| {
            const declaration = declarations.next().?;

            const type_id = graph.types.resolveView(resolving, declaration.value) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return fail(graph, source, source_map, reporter.diagnostic.?);
            };

            port.* = .{ .module = owner, .kind = if (index % 2 == 0) .input else .output, .type_id = type_id };
        }

        start = end;
    }

    return ports;
}

fn invalid(graph: *Graph, source: Source, source_map: SourceMap) zx.Error {
    return graph.reporter.fail(.syntax, source.span(source_map, 0), "Args declarations must contain only ZX types");
}

fn fail(graph: *Graph, source: Source, source_map: SourceMap, issue: zx.Diagnostic) zx.Error {
    return graph.reporter.fail(issue.code, source.span(source_map, issue.span.start), try graph.allocator.dupe(u8, issue.message));
}
