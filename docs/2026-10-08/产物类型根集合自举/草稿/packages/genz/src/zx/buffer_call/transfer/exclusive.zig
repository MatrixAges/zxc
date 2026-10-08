const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../../lower.zig");
const Graph = @import("../../iteration_buffer/ownership/graph.zig");
const flow = @import("../analysis/flow.zig");

pub fn check(lowering: *Lower, argument: ir.ExprId, path: []const u32) std.mem.Allocator.Error!bool {
    const program = lowering.program;
    const value = program.expression(argument).value;

    if (path.len != 1 or value != .object or program.body.control.parallel_values.len != 0 or program.contracts.count() != 0) return false;

    const selected = for (0..value.object.fields.len) |index| {
        const field = value.object.fields.at(index);

        if (field.index == path[0]) break field.value;
    } else return false;

    const projection = switch (program.expression(selected).value) {
        .field, .tuple_field => |field| field,
        else => return false,
    };

    const target = program.expression(projection.target).value;

    if (target != .reference) return false;

    var arena = std.heap.ArenaAllocator.init(lowering.allocator);

    defer arena.deinit();

    const allocator = arena.allocator();
    const graph = try Graph.create(allocator, program);
    const symbol = @backingInt(target.reference);

    if (graph.regions[@backingInt(argument)] != 0 or graph.uses[@backingInt(argument)] != 1 or graph.uses[@backingInt(selected)] != 1) return false;

    const binding = graph.bindings[symbol] orelse return false;
    const producer = program.expression(binding).value;

    if (producer != .call or graph.regions[@backingInt(binding)] != 0 or graph.uses[@backingInt(binding)] != 1) return false;

    var references: usize = 0;

    for (0..program.expressions.count()) |index| {
        const expression = program.expressions.at(index);

        if (expression.value != .reference or expression.value.reference != target.reference) continue;
        if (graph.regions[index] != 0 or graph.uses[index] == 255) return false;

        references += 1;

        var uses: usize = 0;

        for (0..program.expressions.count()) |parent| {
            const observer = program.expressions.at(parent);

            const field = switch (observer.value) {
                .field, .tuple_field => |field| field,
                else => continue,
            };

            if (@backingInt(field.target) != index) continue;
            if (parent != @backingInt(selected) and !flow.detached(program, observer.type_id)) return false;

            uses += 1;
        }

        if (uses != graph.uses[index]) return false;
    }

    if (references != graph.references[symbol] or references >= 255) return false;

    return @import("fresh.zig").check(.{ .program = program, .pure = lowering.pure_functions, .allocated = lowering.allocated_functions }, allocator, producer.call.function, projection.index);
}
