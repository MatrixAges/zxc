const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("module.zig");
const Graph = @import("inference/types.zig");
const SourceMap = @import("source_map.zig");
const prepare = @import("project/prepare.zig");
const Inputs = @import("project/call_inputs.zig");
const target = @import("call/target.zig");
pub const source_graph = @import("project/source_graph.zig");
pub const History = @import("project/history.zig").History;
pub const ModuleDigest = @import("project/history.zig").Digest;

pub const Options = struct {
    entry: []const u8,
    exports: []const Export = &.{},
    modules: []const rx.ModuleSource,
    stores: []const rx.ModuleSource = &.{},
    sources: []const frontend.project.Source,
    project: frontend.project.Options = .{ .entry = "" },
    /// Backing for temporary analysis arenas when `allocator` itself retains freed allocations.
    scratch_allocator: ?std.mem.Allocator = null,
    /// Shared with earlier source graph passes so each module is parsed once; it must outlive the result.
    parse_cache: ?*frontend.project.ParseCache = null,
    /// Reuses modules of the analysis it names; the parse cache must then keep the results that analysis used.
    history: ?*History = null,
};

pub const Export = struct { name: []const u8, path: []const u8 };

pub fn infer(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Module.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try inferIn(arena.allocator(), options.scratch_allocator orelse allocator, options);

    return .{ .arena = arena, .value = value };
}

fn inferIn(allocator: std.mem.Allocator, backing: std.mem.Allocator, raw_options: Options) std.mem.Allocator.Error!Module.Value {
    var options = raw_options;

    options.sources = switch (try frontend.project.prepareSources(allocator, options.sources, options.project)) {
        .sources => |items| items,
        .diagnostic => |issue| {
            const source = options.sources[issue.source_index.?];
            const location = zx.source.locate(source.source, issue.span.start);

            return failure(allocator, .{ .path = source.path, .location = .{ .offset = issue.span.start, .line = location.line, .column = location.column }, .code = @tagName(issue.code), .message = issue.message });
        },
    };

    var local = frontend.project.ParseCache{ .allocator = allocator };

    defer local.deinit();

    const cache = options.parse_cache orelse &local;
    const earlier = if (options.history) |record| if (record.bodies_only) if (record.previous) |*value| value.derived else null else null else null;
    var inputs: Inputs = .{ .arena = .init(backing) };

    defer inputs.arena.deinit();

    const derived = earlier orelse switch (try derive(allocator, backing, options, cache, &inputs)) {
        .frame => |frame| frame,
        .diagnostic => |issue| return remap(allocator, options, issue),
    };

    var result = try @import("project/mixed.zig").compile(allocator, backing, derived, options.modules, options.sources, options.exports, cache, options.history, &inputs);

    if (result == .diagnostic) return remap(allocator, options, result.diagnostic);

    for (derived.definitions) |*definition| {
        definition.types = result.contract.types;

        const objects = try allocator.dupe(@import("store.zig").Object, definition.objects);

        for (objects) |*object| {
            object.initial.types = result.contract.types;
            object.initial.native_modules = result.contract.native_modules;
        }

        definition.objects = objects;
    }

    result.contract.store_definitions = derived.definitions;

    return result;
}

const Derived = union(enum) { frame: @import("project/history.zig").Frame, diagnostic: target.Diagnostic };

/// Everything the module analysis needs besides the ZX function bodies: the source graph, the Store registry, the
/// signatures and the RX constraints. It lives as long as `allocator`, since a later analysis may reuse it.
fn derive(allocator: std.mem.Allocator, backing: std.mem.Allocator, raw_options: Options, cache: *frontend.project.ParseCache, inputs: *Inputs) std.mem.Allocator.Error!Derived {
    var options = raw_options;
    options.project.source_index = try frontend.project.source_index.buildIn(allocator, options.sources, options.project.root_dir);

    const registered = try allocator.dupe(rx.ModuleSource, options.modules);

    for (registered) |*source| {
        const owner = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source.path });
        source.packages = rx.module_reference.dependencies(options.project, owner);
    }

    const checked = try rx.validateModulePaths(allocator, registered);

    if (checked.value == .diagnostic) {
        const issue = checked.value.diagnostic;

        return failed(allocator, .{ .path = options.modules[issue.source_index].path, .location = issue.issue.location, .code = @tagName(issue.issue.code), .message = issue.issue.message });
    }

    const is_zx = std.mem.endsWith(u8, options.entry, ".zx");

    const entry = if (is_zx)
        try std.fs.path.resolve(allocator, &.{ options.project.root_dir, options.entry })

    else
        rx.normalizeModulePath(allocator, options.entry) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return failed(allocator, .{ .path = options.entry, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "entry must name a registered source module inside the project root" });
        };

    const modules = try allocator.alloc(rx.ModuleSource, options.modules.len);

    for (registered, checked.value.data, modules) |source, path, *item| {
        item.* = source;
        item.path = path;
    }

    const entry_index = if (is_zx) null else prepare.find(modules, entry) orelse return failed(allocator, .{ .path = entry, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "RX entry is not registered in the module collection" });
    const roots = try allocator.alloc([]const u8, modules.len + options.exports.len);

    for (modules, roots[0..modules.len]) |module, *path| path.* = module.path;
    for (options.exports, roots[modules.len..]) |exported, *path| path.* = exported.path;

    var paths = frontend.project.source_index.Map.empty;

    defer paths.deinit(backing);

    const dependencies = try source_graph.build(allocator, .{
        .entry = entry,
        .additional_roots = roots,
        .sources = options.sources,
        .modules = modules,
        .stores = options.stores,
        .project = options.project,
        .parse_cache = cache,
        .scratch_allocator = backing,
        .registered_paths = &paths,
    });

    if (dependencies.value == .diagnostic) return failed(allocator, dependencies.value.diagnostic);

    var project = options.project;
    var signature_entries: std.ArrayList([]const u8) = .empty;

    for (dependencies.value.graph.order) |index| {
        const source = dependencies.value.graph.modules[index].source;

        if (source == .zx) try signature_entries.append(allocator, options.sources[source.zx].path);
    }

    const earlier = if (options.history) |record| if (options.stores.len == 0) record.signatures(options.sources, signature_entries.items) else null else null;

    const signatures = earlier orelse analyzed: {
        const result = try frontend.project.analyzeSignaturesWithCache(allocator, options.sources, signature_entries.items, project, cache);

        if (result.value == .diagnostic) {
            const issue = result.value.diagnostic;
            const source = if (issue.source_index) |index| options.sources[index] else null;
            const location: zx.source.Location = if (source) |value| zx.source.locate(value.source, issue.span.start) else .{ .line = 1, .column = 1 };

            return failed(allocator, .{
                .path = if (source) |value| value.path else entry,
                .location = .{ .offset = issue.span.start, .line = location.line, .column = location.column },
                .code = @tagName(issue.code),
                .message = issue.message,
            });
        }

        break :analyzed result.value.data;
    };

    if (earlier != null) options.history.?.signatures_reused = true;

    project.context.types = signatures.types;
    project.context.nominal_types = signatures.nominal_types;
    project.context.native_modules = signatures.native_modules;
    const graph_modules = dependencies.value.graph.modules;
    const rx_modules = graph_modules[options.sources.len..][0..modules.len];
    const store_modules = graph_modules[options.sources.len + modules.len ..];
    const indexed = try source_graph.Signatures.init(allocator, dependencies.value.graph, signatures.modules, &paths);

    paths.deinit(backing);

    paths = .empty;

    const registry = try @import("store/registry.zig").loadSignaturesIn(allocator, backing, options.stores, project.context, store_modules, indexed);

    if (registry == .diagnostic) return .{ .diagnostic = registry.diagnostic };

    project.context = registry.data.context;

    const prepared = try prepare.loadSignatures(allocator, backing, modules, rx_modules, project, registry.data.definitions, indexed, inputs);

    if (prepared == .diagnostic) return .{ .diagnostic = prepared.diagnostic };

    const source_map = SourceMap.init(backing, modules) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failed(allocator, .{ .path = entry, .location = if (entry_index) |index| modules[index].node.location else .{ .offset = 0, .line = 1, .column = 1 }, .code = "unsupported", .message = "RX source positions exceed the supported address range" });
    };

    defer source_map.deinit(backing);

    const inferred = inference: {
        var workspace = zx.Arena.init(backing);

        defer workspace.deinit();

        var reporter: zx.Reporter = .{};
        var graph: Graph = undefined;
        var requests: @import("project/signatures/requests.zig") = .{};

        defer requests.deinit(backing);

        const ports = solve: {
            var pending = zx.Arena.init(backing);

            defer pending.deinit();

            graph = Graph.init(.{
                .graph = workspace.allocator(),
                .pending = pending.allocator(),
                .result = allocator,
                .backing = backing,
            }, &reporter, prepared.loaded.project.context.types) catch |err| return reported(allocator, source_map, reporter, err);

            const ports = @import("project/constraints.zig").collect(&graph, prepared.loaded.modules, source_map, inputs, &requests) catch |err| return reported(allocator, source_map, reporter, err);

            graph.finish() catch |err| return reported(allocator, source_map, reporter, err);

            graph.pending = undefined;

            break :solve ports;
        };

        const resolved = @import("project/signatures.zig").resolve(allocator, &graph, ports, requests) catch |err| return reported(allocator, source_map, reporter, err);

        break :inference .{ .signatures = resolved, .types = graph.types.items.view() };
    };

    return .{ .frame = .{
        .modules = modules,
        .stores = options.stores,
        .dependencies = dependencies.value.graph,
        .definitions = registry.data.definitions,
        .loaded = try prepare.completeShortcuts(allocator, prepared.loaded, inferred.signatures),
        .signatures = signatures,
        .signature_indices = indexed.indices,
        .resolved = inferred.signatures,
        .types = inferred.types,
    } };
}

fn failed(allocator: std.mem.Allocator, issue: target.Diagnostic) std.mem.Allocator.Error!Derived {
    const value = try failure(allocator, issue);

    return .{ .diagnostic = value.diagnostic };
}

fn reported(allocator: std.mem.Allocator, source_map: SourceMap, reporter: zx.Reporter, err: zx.Error) std.mem.Allocator.Error!Derived {
    const value = try report(allocator, source_map, reporter, err);

    return .{ .diagnostic = value.diagnostic };
}

fn report(allocator: std.mem.Allocator, source_map: SourceMap, reporter: zx.Reporter, err: zx.Error) std.mem.Allocator.Error!Module.Value {
    if (err == error.OutOfMemory) return error.OutOfMemory;

    const issue = reporter.diagnostic.?;
    const origin = source_map.locate(issue.span.start).?;

    return failure(allocator, .{ .path = origin.path, .location = origin.location, .code = @tagName(issue.code), .message = issue.message });
}

fn failure(allocator: std.mem.Allocator, issue: target.Diagnostic) std.mem.Allocator.Error!Module.Value {
    const value = try target.failure(allocator, issue);

    return .{ .diagnostic = value.diagnostic };
}

fn remap(allocator: std.mem.Allocator, options: Options, issue: target.Diagnostic) std.mem.Allocator.Error!Module.Value {
    for (options.sources) |source| {
        if (source.template_origins.len == 0) continue;

        const path = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source.path });

        if (!std.mem.eql(u8, path, issue.path)) continue;

        const origin = frontend.project.resources.locate(source, issue.location.offset);
        const position = zx.source.locate(origin.source, origin.offset);

        return failure(allocator, .{ .path = origin.path, .location = .{ .offset = origin.offset, .line = position.line, .column = position.column }, .code = issue.code, .message = issue.message });
    }

    return failure(allocator, issue);
}
