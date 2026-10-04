const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("module.zig");
const Graph = @import("inference/types.zig");
const SourceMap = @import("source_map.zig");
const prepare = @import("project/prepare.zig");
const target = @import("call/target.zig");

pub const Options = struct {
    entry: []const u8,
    modules: []const rx.ModuleSource,
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
    var checked = try rx.validateModules(allocator, options.modules);

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

    for (options.modules, checked.value.data, modules) |source, module, *item| item.* = .{ .path = module.path, .node = source.node };

    const entry_index = prepare.find(modules, entry) orelse return failure(allocator, .{ .path = entry, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "RX entry is not registered in the module collection" });
    const prepared = try prepare.load(allocator, modules, options.sources, options.project);

    if (prepared == .diagnostic) return .{ .diagnostic = prepared.diagnostic };

    const source_map = SourceMap.init(allocator, modules) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return failure(allocator, .{ .path = entry, .location = modules[entry_index].node.location, .code = "unsupported", .message = "RX source positions exceed the supported address range" });
    };

    var reporter: zx.Reporter = .{};
    var graph = Graph.init(allocator, &reporter, prepared.loaded.project.context.types) catch |err| return report(allocator, source_map, reporter, err);
    const states = @import("project/constraints.zig").collect(&graph, prepared.loaded.modules, source_map) catch |err| return report(allocator, source_map, reporter, err);

    graph.finish() catch |err| return report(allocator, source_map, reporter, err);

    return @import("project/lower.zig").compile(&graph, prepared.loaded, states, checked.dependency_order, source_map, entry_index) catch |err| return report(allocator, source_map, reporter, err);
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
