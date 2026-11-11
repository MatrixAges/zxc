const zx = @import("zx");
const Graph = @import("types.zig");
const ObjectClosure = @import("object_closure.zig");

pub const Part = struct { name: ?[]const u8, value: Graph.Id, span: zx.Span };
pub const Object = struct { result: Graph.Id, parts: []const Part, span: zx.Span };

pub fn propagate(graph: *Graph, closure: *ObjectClosure, object: Object, final: bool) zx.Error!void {
    if (!@import("rx_options").generated_graph) return @import("construction/seed.zig").propagate(graph, closure, object, final);

    return @import("construction/project.zig").propagate(graph, closure, object, final);
}
