const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const Graph = @import("../source_graph/model.zig").Graph;
const Module = frontend.project.signature_project.Module;
const Self = @This();

graph: Graph,
modules: []const Module,
indices: []const ?usize,
pub fn init(allocator: std.mem.Allocator, scratch: std.mem.Allocator, graph: Graph, modules: []const Module) std.mem.Allocator.Error!Self {
    var paths: zx.bytes.Map(usize) = .empty;

    defer paths.deinit(scratch);

    try paths.ensureTotalCapacity(scratch, @intCast(modules.len));

    for (modules, 0..) |module, index| {
        const entry = paths.getOrPutAssumeCapacity(module.path);

        if (!entry.found_existing) entry.value_ptr.* = index;
    }

    const indices = try allocator.alloc(?usize, graph.modules.len);

    for (graph.modules, indices) |module, *index| index.* = paths.get(module.path);

    return .{ .graph = graph, .modules = modules, .indices = indices };
}

pub fn get(self: Self, target: usize) ?*const Module {
    return &self.modules[self.indices[target] orelse return null];
}
