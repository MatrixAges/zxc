const std = @import("std");
const Graph = @import("types.zig");
const project = @import("object_closure/project.zig");
const Self = @This();
pub const Query = enum { spread, selection };

arena: std.heap.ArenaAllocator,
snapshot: ?project.Snapshot = null,
revision: usize = 0,
spread: ?[]const bool = null,
selection: ?[]const bool = null,
pub fn init(allocator: std.mem.Allocator) Self {
    return .{ .arena = .init(allocator) };
}

pub fn deinit(self: *Self) void {
    self.arena.deinit();
}

pub fn prove(self: *Self, graph: *const Graph, value: Graph.Id, query: Query) std.mem.Allocator.Error!bool {
    const root = graph.root(value);

    if (graph.nodes.items(.kind)[@backingInt(root)] == .Known) return true;
    if (graph.constructions.len == 0 and graph.selections.len == 0) return false;
    if (!@import("rx_options").generated_graph) return @import("object_closure/seed.zig").prove(graph, root, query, 0);

    const allocator = self.arena.allocator();

    if (self.snapshot == null or self.revision != graph.object_revision) {
        _ = self.arena.reset(.retain_capacity);
        self.snapshot = try project.build(graph, allocator);
        self.revision = graph.object_revision;
        self.spread = null;
        self.selection = null;
    }

    const snapshot = &self.snapshot.?;
    const index = snapshot.position(root) orelse return false;

    const cached = switch (query) {
        .spread => &self.spread,
        .selection => &self.selection,
    };

    const ready = cached.* orelse result: {
        const generated = @import("generated_object_closure");

        const ready = generated.executeValue(allocator, &.{
            .known = snapshot.known,
            .sizes = snapshot.sizes,
            .results = snapshot.results,
            .offsets = snapshot.offsets,
            .dependents = snapshot.dependents,
            .constructions = graph.constructions.len,
            .spread = query == .spread,
        }) catch |err| switch (err) {
            error.OutOfMemory, error.Overflow => return error.OutOfMemory,
            error.IndexOutOfBounds => unreachable,
        };

        cached.* = ready;

        if (graph.selections.len == 0) {
            self.spread = ready;
            self.selection = ready;
        }

        break :result ready;
    };

    return ready[index];
}
