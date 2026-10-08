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

    if (graph.regions[@backingInt(argument)] != 0 or graph.uses[@backingInt(argument)] != 1) return false;

    const selected = try Selection.resolve(allocator, program, graph, argument, path) orelse return false;
    const symbol = @backingInt(selected.symbol);
    const binding = graph.bindings[symbol] orelse return false;
    const producer = program.expression(binding).value;

    if (producer != .call or graph.regions[@backingInt(binding)] != 0 or graph.uses[@backingInt(binding)] != 1) return false;

    const fields = try @import("fresh.zig").paths(.{ .program = program, .pure = lowering.pure_functions, .allocated = lowering.allocated_functions }, allocator, producer.call.function);

    const found = for (fields) |field| {
        if (std.mem.eql(u32, field, selected.path)) break true;
    } else false;

    if (!found) return false;

    const observers = Observers{ .allocator = allocator, .program = program, .graph = graph, .selection = selected };
    var references: usize = 0;

    for (0..program.expressions.count()) |index| {
        const expression = program.expressions.at(index);

        if (expression.value != .reference or expression.value.reference != selected.symbol) continue;
        if (graph.regions[index] != 0 or graph.uses[index] == 255) return false;
        if (!try observers.valid(@fromBackingInt(@intCast(index)), &.{})) return false;

        references += 1;
    }

    return references == graph.references[symbol] and references < 255;
}
