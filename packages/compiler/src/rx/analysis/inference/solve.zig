const std = @import("std");
const zx = @import("zx");
const Graph = @import("types.zig");
const Assignment = @import("assignment.zig");
const Bindings = @import("bindings.zig");
const Construction = @import("construction.zig");
const Index = @import("index.zig");
const NonNull = @import("non_null.zig");
const ObjectClosure = @import("object_closure.zig");
const Projections = @import("projections.zig");
const Selection = @import("selection.zig");
const Sequences = @import("sequences.zig");
const Defaults = @import("sequences/defaults/apply.zig");
const generated = @import("rx_options").generated_graph;
const rule = if (generated) @import("generated_rx_constraint_schedule") else void;
const seed = @import("solve/seed.zig");
const Stage = if (generated) rule.Output else seed.Stage;

const Round = struct {
    graph: *Graph,
    workspace: *std.heap.ArenaAllocator,
    closure: *ObjectClosure,
    revision: usize,
    classes: Assignment.Base = undefined,
    inline fn run(self: *Round, comptime stage: Stage) zx.Error!bool {
        const graph = self.graph;

        switch (stage) {
            .ValidateUses => try Bindings.validateUses(graph),
            .Bindings, .FinalBindings => try Bindings.propagate(graph, stage == .FinalBindings),
            .NonNull, .FinalNonNull => try NonNull.propagate(graph, stage == .FinalNonNull),
            .Sequences => {
                const sequences = graph.pending.sequences.slice();

                for (0..sequences.len) |index| try Sequences.propagate(graph, sequences.get(index));
            },
            .Constructions, .FinalConstructions => {
                for (0..graph.pending.constructions.len) |index| {
                    try Construction.propagate(graph, self.closure, graph.pending.constructions.get(index), stage == .FinalConstructions);
                }
            },
            .Selections, .FinalSelections => {
                for (0..graph.pending.selections.len) |index| {
                    try Selection.propagate(graph, self.closure, graph.pending.selections.get(index), stage == .FinalSelections);
                }
            },
            .Lengths => try Projections.applyLengths(graph),
            .Indexes => try Index.replay(graph),
            .AssignmentClasses => {
                _ = self.workspace.reset(.retain_capacity);
                self.classes = try Assignment.Base.init(graph, self.workspace.allocator());

                try self.classes.propagate(graph);
            },
            .SequenceDefault => return Defaults.apply(graph, self.classes, self.workspace.allocator()),
            .Materialize => try Assignment.materialize(graph, self.classes, self.workspace.allocator()),
            .IndexDefault => return Index.defaultLists(graph),
            .ValidateLengths => try Projections.validateLengths(graph),
            .ValidateAssignments => try Assignment.validate(graph),
            .Restart, .Done => unreachable,
        }

        return graph.revision != self.revision;
    }
};

pub fn finish(graph: *Graph) zx.Error!void {
    var workspace = std.heap.ArenaAllocator.init(graph.scratch);
    var closure = ObjectClosure.init(graph.scratch);

    defer workspace.deinit();
    defer closure.deinit();

    while (true) {
        var round: Round = .{ .graph = graph, .workspace = &workspace, .closure = &closure, .revision = graph.revision };

        if (try execute(&round, .ValidateUses)) return;
    }
}

/// Specializes both continuations at compile time and emits only the required revision checks.
inline fn execute(round: *Round, comptime stage: Stage) zx.Error!bool {
    switch (stage) {
        .Done => return true,
        .Restart => return false,
        else => {},
    }

    const unchanged = comptime advance(stage, false);
    const changed = comptime advance(stage, true);
    const modified = try round.run(stage);

    if (changed != unchanged and modified) return execute(round, changed);

    return execute(round, unchanged);
}

fn advance(comptime stage: Stage, comptime changed: bool) Stage {
    if (!generated) return seed.advance(stage, changed);

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return rule.executeValue(empty.allocator(), &.{ .stage = stage, .changed = changed }) catch unreachable;
}
