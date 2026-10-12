const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("module.zig");
const Graph = @import("inference/types.zig");
const SourceMap = @import("source_map.zig");
const prepare = @import("project/prepare.zig");
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
    /// Shared with earlier source graph passes so each module is parsed once; it must outlive the result.
    parse_cache: ?*frontend.project.ParseCache = null,
    /// Reuses modules of the analysis it names; the parse cache must then keep the results that analysis used.
    history: ?*History = null,
};

pub const Export = struct { name: []const u8, path: []const u8 };

pub fn infer(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Module.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try inferIn(arena.allocator(), allocator, options);

    return .{ .arena = arena, .value = value };
}

fn inferIn(allocator: std.mem.Allocator, backing: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Module.Value {
    var local = frontend.project.ParseCache{ .allocator = allocator };

    defer local.deinit();

    const cache = options.parse_cache orelse &local;
    const earlier = if (options.history) |record| if (record.bodies_only) if (record.previous) |*value| value.derived else null else null else null;

    const derived = earlier orelse switch (try derive(allocator, options, cache)) {
        .frame => |frame| frame,
        .diagnostic => |issue| return .{ .diagnostic = issue },
    };

    var result = try @import("project/mixed.zig").compile(allocator, backing, derived, options.modules, options.sources, options.exports, cache, options.history);

    if (result == .diagnostic) return result;

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
fn derive(allocator: std.mem.Allocator, options: Options, cache: *frontend.project.ParseCache) std.mem.Allocator.Error!Derived {
    const registered = try allocator.dupe(rx.ModuleSource, options.modules);

    for (registered) |*source| {
        const owner = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source.path });
        source.packages = rx.module_reference.dependencies(options.project, owner);
    }

    const checked = try rx.validateModules(allocator, registered);

    if (checked.value == .diagnostic) {
        const issue = checked.value.diagnostic;

        return failed(allocator, .{ .path = options.modules[issue.source_index].path, .location = issue.issue.location, .code = @tagName(issue.issue.code), .message = issue.issue.message });
    }

    const entry = rx.normalizeModulePath(allocator, options.entry) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failed(allocator, .{ .path = options.entry, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "RX entry must be an ordinary module inside the project root" });
    };

    const modules = try allocator.alloc(rx.ModuleSource, options.modules.len);

    for (registered, checked.value.data, modules) |source, module, *item| item.* = .{ .path = module.path, .node = source.node, .packages = source.packages };

    const entry_index = prepare.find(modules, entry) orelse return failed(allocator, .{ .path = entry, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "RX entry is not registered in the module collection" });
    const roots = try allocator.alloc([]const u8, modules.len);

    for (modules, roots) |module, *path| path.* = module.path;

    const dependencies = try source_graph.build(allocator, .{
        .entry = entry,
        .additional_roots = roots,
        .sources = options.sources,
        .modules = modules,
        .project = options.project,
        .parse_cache = cache,
    });

    if (dependencies.value == .diagnostic) return failed(allocator, dependencies.value.diagnostic);

    const registry = try @import("store/registry.zig").load(allocator, options.stores, options.project.context);

    if (registry == .diagnostic) return .{ .diagnostic = registry.diagnostic };

    var project = options.project;
    project.context = registry.data.context;

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

    const prepared = try prepare.loadSignatures(allocator, modules, options.sources, project, registry.data.definitions, signatures);

    if (prepared == .diagnostic) return .{ .diagnostic = prepared.diagnostic };

    const source_map = SourceMap.init(allocator, modules) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failed(allocator, .{ .path = entry, .location = modules[entry_index].node.location, .code = "unsupported", .message = "RX source positions exceed the supported address range" });
    };

    var reporter: zx.Reporter = .{};
    var graph = Graph.init(allocator, &reporter, prepared.loaded.project.context.types) catch |err| return reported(allocator, source_map, reporter, err);
    const states = @import("project/constraints.zig").collect(&graph, prepared.loaded.modules, source_map) catch |err| return reported(allocator, source_map, reporter, err);

    graph.finish() catch |err| return reported(allocator, source_map, reporter, err);

    const resolved = @import("project/signatures.zig").resolve(&graph, states) catch |err| return reported(allocator, source_map, reporter, err);

    return .{ .frame = .{
        .modules = modules,
        .dependencies = dependencies.value.graph,
        .definitions = registry.data.definitions,
        .loaded = prepared.loaded,
        .signatures = signatures,
        .resolved = resolved,
        .types = graph.types.items.view(),
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
