const zx = @import("zx");
const Graph = @import("types.zig");
const ObjectClosure = @import("object_closure.zig");

pub const Part = struct { name: ?[]const u8, value: Graph.Id, span: zx.Span };

pub const Object = struct {
    result: Graph.Id,
    first: u64,
    count: u64,
    span: zx.Span,
    pub fn part(self: Object, graph: *const Graph, index: usize) Part {
        return graph.pending.construction_parts.get(@as(usize, @intCast(self.first)) + index);
    }
};

pub fn propagate(graph: *Graph, closure: *ObjectClosure, object: Object, final: bool) zx.Error!void {
    if (!@import("rx_options").generated_graph) return @import("construction/seed.zig").propagate(graph, closure, object, final);

    return @import("construction/project.zig").propagate(graph, closure, object, final);
}
