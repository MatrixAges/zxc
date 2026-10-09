const std = @import("std");
const rx = @import("rx");
const frontend = @import("frontend");
const model = @import("source_graph/model.zig");
const Collector = @import("source_graph/collect.zig");
pub const Result = model.Result;
pub const Graph = model.Graph;

pub const Options = struct {
    entry: []const u8,
    additional_roots: []const []const u8 = &.{},
    sources: []const frontend.project.Source,
    modules: []const rx.ModuleSource,
    project: frontend.project.Options,
};

pub fn build(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!Result {
    var arena = std.heap.ArenaAllocator.init(allocator);

    errdefer arena.deinit();

    const value = try buildIn(arena.allocator(), options);

    return .{ .arena = arena, .value = value };
}

fn buildIn(allocator: std.mem.Allocator, options: Options) std.mem.Allocator.Error!model.Value {
    const modules = try allocator.alloc(model.Module, options.sources.len + options.modules.len);
    var paths: std.StringHashMapUnmanaged(usize) = .empty;

    defer paths.deinit(allocator);

    for (modules, 0..) |*module, index| {
        const is_zx = index < options.sources.len;
        const source_index = if (is_zx) index else index - options.sources.len;
        const source_path = if (is_zx) options.sources[source_index].path else options.modules[source_index].path;
        const location: rx.ast.Location = if (is_zx) .{ .offset = 0, .line = 1, .column = 1 } else options.modules[source_index].node.location;

        if (!is_zx) {
            const normalized = rx.normalizeModulePath(allocator, source_path) catch |err| {
                if (err == error.OutOfMemory) return error.OutOfMemory;

                return failure(allocator, source_path, location, "RX module registration requires a project relative ordinary module path");
            };

            allocator.free(normalized);
        }

        const path = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source_path });
        const registered = try paths.getOrPut(allocator, path);

        if (registered.found_existing) return failure(allocator, path, location, "source module paths must be unique after normalization across RX and ZX");

        registered.value_ptr.* = index;
        module.* = .{ .path = path, .source = if (is_zx) .{ .zx = source_index } else .{ .rx = source_index } };
    }

    const path = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, options.entry });
    const entry = paths.get(path) orelse return failure(allocator, path, .{ .offset = 0, .line = 1, .column = 1 }, "entry module is missing from the registered source set");
    const roots = try allocator.alloc(usize, options.additional_roots.len + 1);

    roots[0] = entry;

    for (options.additional_roots, roots[1..]) |source_path, *root| {
        const resolved = try std.fs.path.resolve(allocator, &.{ options.project.root_dir, source_path });

        root.* = paths.get(resolved) orelse return failure(allocator, resolved, .{ .offset = 0, .line = 1, .column = 1 }, "source graph root is missing from the registered input set");
    }

    var collector = Collector{ .allocator = allocator, .options = options.project, .modules = modules, .paths = paths };

    @import("source_graph/scan.zig").run(&collector, roots, options.sources, options.modules) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = collector.issue.? };
    };

    return switch (try @import("source_graph/order.zig").build(allocator, modules, roots)) {
        .order => |order| .{ .graph = .{ .modules = modules, .order = order, .entry = entry } },
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
