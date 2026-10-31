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

    if (source.entries.items.len == 0) return &.{};

    var parsed = try frontend.parse(graph.allocator, source.text.items, modules[source.entries.items[0].module].source.path);

    defer parsed.deinit();

    if (parsed.value == .diagnostic) return fail(graph, source, source_map, parsed.value.diagnostic);

    const program = parsed.value.parsed.ast;

    if (!source.valid(program)) return graph.reporter.fail(.syntax, source.span(source_map, 0), "Input and Output declarations must contain only ZX types");

    const previous_declarations = graph.types.declarations;
    const previous_resolved = graph.types.resolved;
    const previous_reporter = graph.types.reporter;
    var reporter: zx.Reporter = .{};

    graph.types.declarations = program.declarations;
    graph.types.resolved = .empty;
    graph.types.reporter = &reporter;

    defer {
        graph.types.declarations = previous_declarations;

        graph.types.resolved.deinit(graph.allocator);

        graph.types.resolved = previous_resolved;
        graph.types.reporter = previous_reporter;
    }

    graph.types.initialize() catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return fail(graph, source, source_map, reporter.diagnostic.?);
    };

    const ports = try graph.allocator.alloc(Port, source.entries.items.len);

    for (source.entries.items, ports) |entry, *port| {
        port.* = .{ .module = entry.module, .kind = entry.kind, .type_id = graph.types.resolved.get(entry.name).? };
    }

    return ports;
}

fn fail(graph: *Graph, source: Source, source_map: SourceMap, issue: zx.Diagnostic) zx.Error {
    return graph.reporter.fail(issue.code, source.span(source_map, issue.span.start), try graph.allocator.dupe(u8, issue.message));
}
