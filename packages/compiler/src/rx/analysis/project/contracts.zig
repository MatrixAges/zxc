const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const Graph = @import("../inference/types.zig");
const Prepared = @import("prepare.zig");
const SourceMap = @import("../source_map.zig");
const Source = @import("contracts/source.zig");
pub const Port = struct { module: usize, kind: Source.Kind, type_id: zx.ir.TypeId };

pub fn resolve(temporary: std.mem.Allocator, graph: *Graph, modules: []const Prepared.Module, source_map: SourceMap) zx.Error![]const Port {
    var source = Source{ .allocator = temporary };

    try source.collect(modules);

    const owners = source.entries.items(.module);

    if (owners.len == 0) return &.{};

    var parsed = try frontend.parseModule(temporary, source.text, modules[@intCast(owners[0])].source.path);

    defer parsed.deinit();

    if (parsed.diagnostic()) |issue| return fail(graph, source, source_map, issue);

    switch (parsed) {
        .native => |native| {
            const program = native.value.parsed.ast;
            const view = frontend.type_views.Native{ .items = program.declarations };

            if (!validSeed(source, view, program.imports.len, program.constants.len, program.contracts.len, program.body != null, program.has_store)) return invalid(graph, source, source_map);

            return resolveDeclarations(graph, modules, source, source_map, view);
        },
        .indexed => |indexed| if (comptime @TypeOf(indexed) != void) {
            const output = indexed.output;
            const view = frontend.type_views.Indexed(@TypeOf(output)){ .source = indexed.source, .storage = output };

            const valid = if (@import("rx_options").generated_graph)
                validIndexed(source, indexed.source, output)
            else
                validSeed(source, view, output.imports.len, output.constants.len, output.contracts.len, output.body != null, output.has_store);

            if (!valid) return invalid(graph, source, source_map);

            return resolveDeclarations(graph, modules, source, source_map, view);
        } else unreachable,
    }
}

fn validIndexed(source: Source, text: []const u8, output: anytype) bool {
    const rule = @import("generated_rx_args_validate");
    const Input = std.meta.Child(rule.Input);
    const Names = std.meta.Child(@FieldType(Input, "names"));

    const names: Names = .{
        .text = text,
        .expected = source.names,
        .declarations = zx.columns.slice(@FieldType(Names, "declarations"), output.declarations),
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return rule.executeValue(empty.allocator(), &.{
        .has_imports = output.imports.len != 0,
        .has_constants = output.constants.len != 0,
        .has_contracts = output.contracts.len != 0,
        .has_body = output.body != null,
        .has_store = output.has_store,
        .names = &names,
    }) catch unreachable;
}

fn validSeed(source: Source, view: anytype, imports: usize, constants: usize, contracts: usize, body: bool, store: bool) bool {
    if (imports != 0 or constants != 0 or contracts != 0 or body or store) return false;

    const declarations = view.declarations();

    if (declarations.count() != source.names.len) return false;

    var iterator = declarations.iterator();

    for (source.names) |name| {
        if (!std.mem.eql(u8, iterator.next().?.name.text, name)) return false;
    }

    return true;
}

fn resolveDeclarations(graph: *Graph, modules: []const Prepared.Module, source: Source, source_map: SourceMap, view: anytype) zx.Error![]const Port {
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
    const ports = try source.allocator.alloc(Port, owners.len);
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
