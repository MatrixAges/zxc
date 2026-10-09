const std = @import("std");
const compiler = @import("compiler");
const rx = @import("rx");
const analysis = @import("rx_analysis");

pub fn reachable(allocator: std.mem.Allocator, modules: []const rx.ModuleSource, sources: []const compiler.project.Source, entry: []const u8, project: compiler.project.Options) ![]const rx.ModuleSource {
    var result = try analysis.project.source_graph.build(allocator, .{ .entry = entry, .modules = modules, .sources = sources, .project = project });

    defer result.deinit();

    if (result.value == .diagnostic) {
        const issue = result.value.diagnostic;

        std.debug.print("{s}:{d}:{d}: {s}: {s}\n", .{ issue.path, issue.location.line, issue.location.column, issue.code, issue.message });

        return error.InvalidSourceGraph;
    }

    var selected: std.ArrayList(rx.ModuleSource) = .empty;

    errdefer selected.deinit(allocator);

    for (result.value.graph.order) |index| {
        const source = result.value.graph.modules[index].source;

        if (source == .rx) try selected.append(allocator, modules[source.rx]);
    }

    return selected.toOwnedSlice(allocator);
}
