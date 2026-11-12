const std = @import("std");
const zx = @import("zx");
const Graph = @import("../../types.zig");
const Base = @import("../../assignment/base.zig");

pub fn apply(graph: *Graph, base: Base, scratch: std.mem.Allocator) zx.Error!bool {
    if (graph.sequences.len == 0) return false;
    if (!@import("rx_options").generated_graph) return @import("seed.zig").apply(graph, base);

    const generated = @import("generated_rx_sequence_default");
    const sequences = graph.sequences.slice();
    const rows = graph.nodes.slice();
    const parents: []u32 = @constCast(graph.forest.state.items);

    const plan = generated.executeValue(scratch, &.{
        .graph = &.{
            .parents = @ptrCast(&parents),
            .kinds = rows.items(.kind),
            .arguments = rows.items(.argument),
            .members = rows.items(.members),
        },
        .classes = &.{
            .initial = base.payloads.initial,
            .registered = base.payloads.registered,
            .groups = base.parents,
            .representatives = base.representatives,
        },
        .sequences = &.{
            .values = @ptrCast(sequences.items(.value)),
            .elements = @ptrCast(sequences.items(.elements)),
        },
    }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow, error.IntegerOverflow => return error.OutOfMemory,
        error.IndexOutOfBounds => unreachable,
    };

    if (plan.route == .Empty) return false;

    const sequence = sequences.get(@intCast(plan.position));

    switch (plan.route) {
        .Empty => unreachable,
        .Depth => return graph.reporter.fail(.unsupported, sequence.span, "type inference nesting exceeds 256 levels"),
        .Recursive => return graph.reporter.fail(.type_mismatch, sequence.span, "sequence construction would require a recursive type"),
        .Select => _ = try graph.payload(sequence.value, .list, sequence.span),
    }

    return true;
}
