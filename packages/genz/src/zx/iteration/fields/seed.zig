const std = @import("std");
const ir = @import("zx").ir;
const Graph = @import("seed_graph.zig");
const capacity = @import("seed_capacity.zig");
const no_origin = std.math.maxInt(u32);

pub const Plan = struct {
    states: []bool,
    symbols: []bool,
    mutable: []bool,
    origins: []u32,
    valid: bool,
    capacity: ?capacity.Capacity = null,
};

/// Initial seed's graph/bindings/proof; formal builds use Source fields/plan.
pub fn create(allocator: std.mem.Allocator, program: ir.Program, iteration: ir.Iteration, type_id: ir.TypeId, candidates: []const bool) std.mem.Allocator.Error!Plan {
    const expressions = program.expressions;

    var graph: Graph = .{
        .allocator = allocator,
        .expressions = expressions,
        .type_id = type_id,
        .seen = try allocator.alloc(bool, expressions.count()),
        .states = try allocator.alloc(bool, expressions.count()),
        .symbols = try allocator.alloc(bool, program.symbols.count()),
    };

    @memset(graph.seen, false);
    @memset(graph.states, false);
    @memset(graph.symbols, false);

    try graph.visit(iteration.body);
    try graph.visit(iteration.condition);

    const mutable = try allocator.alloc(bool, candidates.len);
    const origins = try allocator.alloc(u32, expressions.count());

    @memset(mutable, true);
    @memset(origins, no_origin);

    if (graph.valid) {
        const bindings = try allocator.alloc(?ir.ExprId, program.symbols.count());

        @memset(bindings, null);

        for (expressions.scope_symbols, expressions.scope_values) |symbol, value| if (symbol) |id| {
            bindings[id] = @fromBackingInt(value);
        };

        const states = try allocator.alloc(bool, expressions.count());
        const values = try allocator.alloc(bool, expressions.count());

        for (candidates, 0..) |candidate, field| {
            if (!candidate) continue;

            @memset(states, false);
            @memset(values, false);

            var preserved = true;

            for (graph.seen, 0..) |seen, index| {
                if (!preserved) break;
                if (!seen) continue;

                const expression = expressions.at(index);
                const bound = if (expression.value == .reference) bindings[@backingInt(expression.value.reference)] else null;

                if (graph.states[index]) {
                    states[index] = state(iteration, expression, bound, field, states, values);
                    preserved = states[index];
                } else if (expression.value == .field and expression.value.field.index == field) {
                    const target = @backingInt(expression.value.field.target);

                    values[index] = graph.states[target] and states[target];
                } else if (bound) |id| {
                    values[index] = values[@backingInt(id)];
                }

                if (values[index]) origins[index] = @intCast(field);
            }

            mutable[field] = !preserved;
        }
    }

    return .{ .states = graph.states, .symbols = graph.symbols, .mutable = mutable, .origins = origins, .valid = graph.valid, .capacity = if (graph.valid) capacity.plan(expressions, iteration, mutable) else null };
}

fn state(iteration: ir.Iteration, expression: ir.ExpressionRow, bound: ?ir.ExprId, field: usize, states: []const bool, values: []const bool) bool {
    return switch (expression.value) {
        .reference => |symbol| symbol == iteration.parameter or symbol == iteration.condition_parameter or (if (bound) |id| states[@backingInt(id)] else false),
        .scope => |scope| states[@backingInt(scope.result)],
        .conditional => |choice| states[@backingInt(choice.yes)] and states[@backingInt(choice.no)],
        .match_expr => |choice| match: {
            if (!states[@backingInt(choice.fallback)]) break :match false;
            for (0..choice.arms.len) |index| if (!states[@backingInt(choice.arms.at(index).result)]) break :match false;

            break :match true;
        },
        .object => |object| object: {
            for (0..object.fields.len) |index| {
                const item = object.fields.at(index);

                if (item.index == field) break :object values[@backingInt(item.value)];
            }

            break :object false;
        },
        else => false,
    };
}
