const std = @import("std");
const zx = @import("zx");
const Graph = @import("../../types.zig");
const Base = @import("../../assignment/base.zig");

pub fn apply(graph: *Graph, base: Base, scratch: std.mem.Allocator) zx.Error!bool {
    if (!@import("rx_options").generated_graph) return @import("seed.zig").apply(graph, base);

    const generated = @import("generated_rx_sequence_default");
    var pending: std.ArrayList(usize) = .empty;
    var element_count: usize = 0;
    var view: View = .{ .graph = graph, .base = base, .scratch = scratch };

    for (graph.sequences.items, 0..) |sequence, index| {
        if (graph.shape(sequence.value) != .sequence) continue;
        try pending.append(scratch, index);

        element_count += sequence.elements.len;

        for (sequence.elements) |element| _ = try view.register(element);
    }

    if (pending.items.len == 0) return false;

    const direct = view.nodes.count();

    try view.expand();

    const candidates = try scratch.alloc(u32, pending.items.len);
    const elements = try scratch.alloc(u32, if (view.children.items.len == 0) 0 else element_count);
    var element_index: usize = 0;

    for (pending.items, candidates) |index, *candidate| {
        const sequence = graph.sequences.items[index];

        candidate.* = try view.register(sequence.value);

        if (elements.len == 0) continue;

        for (sequence.elements) |element| {
            elements[element_index] = view.position(element);
            element_index += 1;
        }
    }

    const plan = generated.executeValue(scratch, &.{
        .candidates = candidates,
        .elements = elements,
        .direct = direct,
        .edges = &.{ .offsets = view.offsets.items, .children = view.children.items },
    }) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    const sequence = graph.sequences.items[pending.items[@intCast(plan.position)]];

    switch (plan.route) {
        .Empty => unreachable,
        .Depth => return graph.reporter.fail(.unsupported, sequence.span, "type inference nesting exceeds 256 levels"),
        .Recursive => return graph.reporter.fail(.type_mismatch, sequence.span, "sequence construction would require a recursive type"),
        .Select => _ = try graph.payload(sequence.value, .list, sequence.span),
    }

    return true;
}

const View = struct {
    graph: *const Graph,
    base: Base,
    scratch: std.mem.Allocator,
    nodes: std.AutoArrayHashMapUnmanaged(Graph.Id, void) = .empty,
    offsets: std.ArrayList(u64) = .empty,
    children: std.ArrayList(u32) = .empty,
    fn register(self: *View, id: Graph.Id) std.mem.Allocator.Error!u32 {
        const result = try self.nodes.getOrPut(self.scratch, self.base.stableRoot(self.graph, id));

        return @intCast(result.index);
    }
    fn position(self: *const View, id: Graph.Id) u32 {
        return @intCast(self.nodes.getIndex(self.base.stableRoot(self.graph, id)).?);
    }
    fn expand(self: *View) std.mem.Allocator.Error!void {
        var index: usize = 0;

        while (index < self.nodes.count()) : (index += 1) {
            const root = self.nodes.keys()[index];
            const start = self.children.items.len;

            switch (self.graph.nodes.items[@backingInt(root)].shape) {
                .list, .optional => |child| try self.append(child),
                .tuple => |children| for (children) |child| try self.append(child),
                .object => |fields| for (fields) |field| try self.append(field.value),
                else => {},
            }

            if (self.children.items.len == 0) continue;
            if (self.offsets.items.len == 0) try self.offsets.appendNTimes(self.scratch, 0, index);
            try self.offsets.append(self.scratch, start);
        }

        if (self.children.items.len != 0) try self.offsets.append(self.scratch, self.children.items.len);
    }

    fn append(self: *View, child: Graph.Id) std.mem.Allocator.Error!void {
        try self.children.append(self.scratch, try self.register(child));
    }
};
