const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const project = @import("frontend").project;
const Collector = @import("collect.zig");
const Frontier = @import("frontier.zig");
const model = @import("model.zig");

pub fn run(collector: *Collector, adjacency: *model.Adjacency, roots: []const u64, sources: []const project.Source, modules: []const rx.ModuleSource, stores: []const rx.ModuleSource, shared: ?*project.ParseCache) Collector.Error!void {
    const backing = collector.backing;
    var local = project.ParseCache{ .allocator = collector.allocator };

    defer local.deinit();

    const cache = shared orelse &local;
    const parsed_modules = try prefetch(backing, sources, collector.modules[0..sources.len], cache);

    defer backing.free(parsed_modules);

    var pending = try Frontier.init(backing, collector.modules.len);

    defer pending.deinit(backing);

    var reused: usize = 0;

    defer cache.reused += reused;

    pending.enqueue(roots);

    while (pending.next()) |index| {
        collector.owner = index;

        const start = collector.targets.items.len;

        switch (collector.modules[index].source) {
            .rx => |source_index| try @import("rx_edges.zig").collect(collector, modules[source_index]),
            .store => |source_index| try @import("rx_edges.zig").collect(collector, stores[source_index]),
            .zx => |source_index| {
                const source = sources[source_index];
                const parsed = parsed_modules[source_index];
                reused += 1;

                if (parsed.diagnostic()) |issue| {
                    const location = zx.source.locate(source.source, issue.span.start);

                    collector.issue = .{
                        .path = collector.modules[index].path,
                        .location = .{ .offset = issue.span.start, .line = location.line, .column = location.column },
                        .code = @tagName(issue.code),
                        .message = try collector.allocator.dupe(u8, issue.message),
                    };

                    return error.InvalidGraph;
                }

                switch (parsed.*) {
                    .native => |result| try @import("zx_edges.zig").collect(collector, zx.syntax.header.Native{ .program = result.value.parsed.ast }, source.source),
                    .indexed => |*result| if (project.ParseCache.indexed_enabled) try @import("zx_edges.zig").collect(collector, result.header(), source.source) else unreachable,
                }
            },
        }

        collector.modules[index].dependencies = try collector.edges.toOwnedSlice(collector.allocator);
        adjacency.starts[index] = start;
        adjacency.ends[index] = collector.targets.items.len;

        pending.enqueue(collector.targets.items[start..]);
    }

    adjacency.targets = collector.targets.items;
}

/// Parses every ZX module of the graph on all cores before the walk reads them in import order.
fn prefetch(allocator: std.mem.Allocator, sources: []const project.Source, modules: []const model.Module, cache: *project.ParseCache) Collector.Error![]*const project.ParseCache.ModuleResult {
    const requests = try allocator.alloc(project.ParseCache.Request, sources.len);

    defer allocator.free(requests);

    for (requests, sources, modules) |*request, source, module| {
        request.* = .{ .source = source.source, .path = module.path };
    }

    const parsed = try allocator.alloc(*const project.ParseCache.ModuleResult, sources.len);

    errdefer allocator.free(parsed);

    try cache.prefetchModules(requests, parsed);

    return parsed;
}
