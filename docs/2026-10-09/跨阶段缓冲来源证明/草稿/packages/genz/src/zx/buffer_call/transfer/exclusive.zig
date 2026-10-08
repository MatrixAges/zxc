const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../../lower.zig");
const Graph = @import("../../iteration_buffer/ownership/graph.zig");
const Selection = @import("selection.zig");
const Observers = @import("observers.zig");

pub fn check(lowering: *Lower, argument: ir.ExprId, path: []const u32) std.mem.Allocator.Error!bool {
    const program = lowering.program;

    if (program.body.control.parallel_values.len != 0 or program.contracts.count() != 0) return false;

    var arena = std.heap.ArenaAllocator.init(lowering.allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    const graph = try Graph.create(allocator, program);
    var current_argument = argument;
    var current_path = path;

    for (0..program.expressions.count()) |_| {
        const argument_index = @backingInt(current_argument);

        if (graph.regions[argument_index] != 0 or graph.uses[argument_index] != 1) return false;

        const selected = try Selection.resolve(allocator, program, graph, current_argument, current_path) orelse return false;
        const binding = graph.bindings[@backingInt(selected.symbol)] orelse return false;
        const producer = program.expression(binding).value;

        if (producer != .call or graph.regions[@backingInt(binding)] != 0 or graph.uses[@backingInt(binding)] != 1) return false;
        if (producer.call.stores.len != 0 or !try consumed(allocator, program, graph, selected)) return false;

        const fields = try @import("fresh.zig").paths(.{ .program = program, .pure = lowering.pure_functions, .allocated = lowering.allocated_functions }, allocator, producer.call.function);

        for (fields) |field| {
            if (std.mem.eql(u32, field, selected.path)) return true;
        }

        const index = @backingInt(producer.call.function);

        const input = for (lowering.buffer_functions[index], lowering.transfer_functions[index]) |lane, capability| {
            if (capability.forwardable and std.mem.eql(u32, lane.output, selected.path)) break lane.input;
        } else return false;

        current_argument = producer.call.argument;
        current_path = input;
    }

    return false;
}

fn consumed(allocator: std.mem.Allocator, program: ir.Program, graph: Graph, selected: Selection) std.mem.Allocator.Error!bool {
    const observers = Observers{ .allocator = allocator, .program = program, .graph = graph, .selection = selected };
    var references: usize = 0;

    for (0..program.expressions.count()) |index| {
        const expression = program.expressions.at(index);

        if (expression.value != .reference or expression.value.reference != selected.symbol) continue;
        if (graph.regions[index] != 0 or graph.uses[index] == 255) return false;
        if (!try observers.valid(@fromBackingInt(@intCast(index)), &.{})) return false;

        references += 1;
    }

    return references == graph.references[@backingInt(selected.symbol)] and references < 255;
}
