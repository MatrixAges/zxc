const std = @import("std");
const rx = @import("rx");
const frontend = @import("frontend");
const model = @import("source_graph/model.zig");
const Collector = @import("source_graph/collect.zig");
pub const Result = model.Result;
pub const Graph = model.Graph;
pub const Reference = model.Reference;
pub const Signatures = @import("references/signatures.zig");
pub const references = @import("source_graph/rx_edges.zig");

pub const Options = struct {
    entry: []const u8,
    additional_roots: []const []const u8 = &.{},
    sources: []const frontend.project.Source,
    modules: []const rx.ModuleSource,
    stores: []const rx.ModuleSource = &.{},
    project: frontend.project.Options,
    parse_cache: ?*frontend.project.ParseCache = null,
    scratch_allocator: ?std.mem.Allocator = null,
    /// Optional caller-owned index, using the scratch allocator.
    registered_paths: ?*frontend.project.source_index.Map = null,
};

pub fn build(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try buildIn(arena.allocator(), options.scratch_allocator orelse allocator, options);

    return .{ .arena = arena, .value = value };
}

fn buildIn(allocator: std.mem.Allocator, backing: std.mem.Allocator, options: Options) std.mem.Allocator.Error!model.Value {
    const modules = try allocator.alloc(model.Module, options.sources.len + options.modules.len + options.stores.len);
    var temporary = frontend.project.source_index.Map.empty;
    const paths = options.registered_paths orelse &temporary;
    paths.* = try frontend.project.source_index.Map.init(backing, modules.len);

    defer temporary.deinit(backing);

    for (modules, 0..) |*module, index| {
        const is_zx = index < options.sources.len;
        const is_store = index >= options.sources.len + options.modules.len;
        const source_index = if (is_zx) index else if (is_store) index - options.sources.len - options.modules.len else index - options.sources.len;
        const source: ?rx.ModuleSource = if (is_zx) null else if (is_store) options.stores[source_index] else options.modules[source_index];
        const source_path = if (source) |item| item.path else options.sources[source_index].path;
        const location: rx.ast.Location = if (source) |item| item.node.location else .{ .offset = 0, .line = 1, .column = 1 };

        if (!is_zx) {
            const normalized = (if (is_store) rx.normalizeStorePath(allocator, source_path) else rx.normalizeModulePath(allocator, source_path)) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return failure(allocator, source_path, location, "RX source registration requires a project relative path of the expected module kind");
            };

            allocator.free(normalized);
        }

        const path = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source_path });

        if (!paths.claim(index, path)) return failure(allocator, if (is_store) source_path else path, location, if (is_store) "Store definition path is already registered" else "source paths must be unique after normalization across RX, ZX and Store definitions");

        module.* = .{ .path = path, .source = if (is_zx) .{ .zx = source_index } else if (is_store) .{ .store = source_index } else .{ .rx = source_index } };
    }

    const path = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, options.entry });
    const entry = paths.get(path) orelse return failure(allocator, path, .{ .offset = 0, .line = 1, .column = 1 }, "entry module is missing from the registered source set");
    const roots = try backing.alloc(u64, options.additional_roots.len + options.stores.len + 1);

    defer backing.free(roots);

    roots[0] = entry;

    const additional_roots = try allocator.alloc(usize, options.additional_roots.len);

    for (options.additional_roots, additional_roots, roots[1..][0..additional_roots.len]) |source_path, *root, *row| {
        const resolved = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source_path });

        root.* = paths.get(resolved) orelse return failure(allocator, resolved, .{ .offset = 0, .line = 1, .column = 1 }, "source graph root is missing from the registered input set");
        row.* = root.*;
    }

    for (roots[1 + options.additional_roots.len ..], 0..) |*root, index| root.* = options.sources.len + options.modules.len + index;

    const starts = try backing.alloc(u64, modules.len + 1);

    defer backing.free(starts);

    const ends = try backing.alloc(u64, modules.len);

    defer backing.free(ends);
    @memset(starts, 0);
    @memset(ends, 0);

    var adjacency: model.Adjacency = .{ .starts = starts, .ends = ends };
    var collector = Collector{ .allocator = allocator, .backing = backing, .options = options.project, .modules = modules, .paths = paths };

    defer collector.targets.deinit(backing);

    if (collector.options.source_index == null) collector.options.source_index = paths;

    @import("source_graph/scan.zig").run(&collector, &adjacency, roots, options.sources, options.modules, options.stores, options.parse_cache) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = collector.issue.? };
    };

    return switch (try @import("source_graph/order.zig").build(allocator, backing, modules, adjacency, roots)) {
        .schedule => |schedule| .{ .graph = .{
            .modules = modules,
            .order = schedule.order,
            .batch_ends = schedule.batch_ends,
            .entry = entry,
            .additional_roots = additional_roots,
        } },
        .diagnostic => |issue| .{ .diagnostic = issue },
    };
}

fn failure(allocator: std.mem.Allocator, path: []const u8, location: rx.ast.Location, message: []const u8) std.mem.Allocator.Error!model.Value {
    return .{ .diagnostic = .{
        .path = try allocator.dupe(u8, path),
        .location = location,
        .code = "module",
        .message = message,
    } };
}
