const std = @import("std");
const frontend = @import("frontend");
const Graph = @import("../source_graph/model.zig").Graph;
const Module = frontend.project.signature_project.Module;
const Self = @This();
pub const Forward = union(enum) { none, missing, module: usize };

graph: Graph,
modules: []const Module,
indices: []const ?usize,
forwards: []const Forward,
pub fn init(allocator: std.mem.Allocator, graph: Graph, modules: []const Module, paths: *const frontend.project.source_index.Map) std.mem.Allocator.Error!Self {
    const indices = try allocator.alloc(?usize, graph.modules.len);
    var forwards: []Forward = &.{};

    @memset(indices, null);

    for (modules, 0..) |module, index| {
        const source = paths.get(module.path) orelse continue;

        if (indices[source] != null) continue;

        indices[source] = index;

        if (module.signature.deferred_source) |path| {
            if (forwards.len == 0) {
                forwards = try allocator.alloc(Forward, modules.len);

                @memset(forwards, .none);
            }

            forwards[index] = .missing;

            const target = paths.get(path) orelse continue;
            const destination = graph.modules[target].source;

            if (destination == .rx) forwards[index] = .{ .module = destination.rx };
        }
    }

    return .{ .graph = graph, .modules = modules, .indices = indices, .forwards = forwards };
}

pub fn forwarded(self: Self, target: usize) Forward {
    return if (self.forwards.len != 0) self.forwards[self.indices[target] orelse return .none] else .none;
}

pub fn get(self: Self, target: usize) ?*const Module {
    return &self.modules[self.indices[target] orelse return null];
}
