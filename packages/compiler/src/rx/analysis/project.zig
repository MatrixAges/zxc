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

pub const Options = struct {
    entry: []const u8,
    modules: []const rx.ModuleSource,
    stores: []const rx.ModuleSource = &.{},
    sources: []const frontend.project.Source,
    project: frontend.project.Options = .{ .entry = "" },
};

pub fn infer(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Module.Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try inferIn(arena.allocator(), options);

    return .{ .arena = arena, .value = value };
}

fn inferIn(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Module.Value {
    const registered = try allocator.dupe(rx.ModuleSource, options.modules);

    for (registered) |*source| {
        const owner = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source.path });
        source.packages = rx.module_reference.dependencies(options.project, owner);
    }

    var checked = try rx.validateModules(allocator, registered);

    defer checked.deinit();

    if (checked.value == .diagnostic) {
        const issue = checked.value.diagnostic;

        return failure(allocator, .{ .path = options.modules[issue.source_index].path, .location = issue.issue.location, .code = @tagName(issue.issue.code), .message = issue.issue.message });
    }

    const entry = rx.normalizeModulePath(allocator, options.entry) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, .{ .path = options.entry, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "RX entry must be an ordinary module inside the project root" });
    };

    const modules = try allocator.alloc(rx.ModuleSource, options.modules.len);

    for (registered, checked.value.data, modules) |source, module, *item| item.* = .{ .path = module.path, .node = source.node, .packages = source.packages };

    const entry_index = prepare.find(modules, entry) orelse return failure(allocator, .{ .path = entry, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "RX entry is not registered in the module collection" });
    const roots = try allocator.alloc([]const u8, modules.len);

    for (modules, roots) |module, *path| path.* = module.path;

    var dependencies = try source_graph.build(allocator, .{
        .entry = entry,
        .additional_roots = roots,
        .sources = options.sources,
        .modules = modules,
        .project = options.project,
    });

    defer dependencies.deinit();

    if (dependencies.value == .diagnostic) return failure(allocator, dependencies.value.diagnostic);

    const registry = try @import("store/registry.zig").load(allocator, options.stores, options.project.context);

    if (registry == .diagnostic) return .{ .diagnostic = registry.diagnostic };

    var project = options.project;
    project.context = registry.data.context;

    var signature_entries: std.ArrayList([]const u8) = .empty;

    for (dependencies.value.graph.order) |index| {
        const source = dependencies.value.graph.modules[index].source;

        if (source == .zx) try signature_entries.append(allocator, options.sources[source.zx].path);
    }

    const signatures = try frontend.project.analyzeSignatures(allocator, options.sources, signature_entries.items, project);

    if (signatures.value == .diagnostic) {
        const issue = signatures.value.diagnostic;
        const source = if (issue.source_index) |index| options.sources[index] else null;
        const location: zx.source.Location = if (source) |value| zx.source.locate(value.source, issue.span.start) else .{ .line = 1, .column = 1 };

        return failure(allocator, .{
            .path = if (source) |value| value.path else entry,
            .location = .{ .offset = issue.span.start, .line = location.line, .column = location.column },
            .code = @tagName(issue.code),
            .message = issue.message,
        });
    }

    const prepared = try prepare.loadSignatures(allocator, modules, options.sources, project, registry.data.definitions, signatures.value.data);

    if (prepared == .diagnostic) return .{ .diagnostic = prepared.diagnostic };

    const source_map = SourceMap.init(allocator, modules) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, .{ .path = entry, .location = modules[entry_index].node.location, .code = "unsupported", .message = "RX source positions exceed the supported address range" });
    };

    var reporter: zx.Reporter = .{};
    var graph = Graph.init(allocator, &reporter, prepared.loaded.project.context.types) catch |err| return report(allocator, source_map, reporter, err);
    const states = @import("project/constraints.zig").collect(&graph, prepared.loaded.modules, source_map) catch |err| return report(allocator, source_map, reporter, err);

    graph.finish() catch |err| return report(allocator, source_map, reporter, err);

    var result = @import("project/mixed.zig").compile(&graph, prepared.loaded, states, dependencies.value.graph, signatures.value.data, options.sources, modules) catch |err| return report(allocator, source_map, reporter, err);

    if (result == .diagnostic) return result;

    for (registry.data.definitions) |*definition| {
        definition.types = result.contract.types;

        const objects = try allocator.dupe(@import("store.zig").Object, definition.objects);

        for (objects) |*object| {
            object.initial.types = result.contract.types;
            object.initial.native_modules = result.contract.native_modules;
        }

        definition.objects = objects;
    }

    result.contract.store_definitions = registry.data.definitions;

    return result;
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
