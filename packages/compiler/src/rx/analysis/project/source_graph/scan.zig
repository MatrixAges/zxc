const std = @import("std");
const rx = @import("rx");
const zx = @import("zx");
const project = @import("frontend").project;
const Collector = @import("collect.zig");

pub fn run(collector: *Collector, roots: []const usize, sources: []const project.Source, modules: []const rx.ModuleSource) Collector.Error!void {
    var cache = project.ParseCache{ .allocator = collector.allocator };

    defer cache.deinit();

    const queued = try collector.allocator.alloc(bool, collector.modules.len);

    defer collector.allocator.free(queued);
    @memset(queued, false);

    var pending: std.ArrayList(usize) = .empty;

    defer pending.deinit(collector.allocator);

    for (roots) |entry| {
        if (queued[entry]) continue;
        try pending.append(collector.allocator, entry);

        queued[entry] = true;
    }

    var cursor: usize = 0;

    while (cursor < pending.items.len) : (cursor += 1) {
        const index = pending.items[cursor];

        collector.owner = index;

        switch (collector.modules[index].source) {
            .rx => |source_index| try @import("rx_edges.zig").collect(collector, modules[source_index]),
            .zx => |source_index| {
                const source = sources[source_index];
                const parsed = try cache.getModule(source.source, collector.modules[index].path);

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

        const dependencies = try collector.edges.toOwnedSlice(collector.allocator);

        collector.modules[index].dependencies = dependencies;

        for (dependencies) |edge| {
            if (edge.target != .source or queued[edge.target.source]) continue;

            queued[edge.target.source] = true;

            try pending.append(collector.allocator, edge.target.source);
        }
    }
}
