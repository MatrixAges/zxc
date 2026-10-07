const std = @import("std");
const ir = @import("zx").ir;
const State = @import("analysis.zig");
const facts = @import("fact.zig");

pub fn evaluate(state: *State, iteration: ir.Iteration, path: []const u32) std.mem.Allocator.Error!facts.Value {
    const selected = try state.allocator.alloc(usize, path.len);

    for (path, selected) |part, *value| value.* = part;

    const initial = try state.expression(iteration.initial);

    if (!state.retains(initial, selected)) {
        state.valid = false;

        return .none;
    }

    const before = try state.snapshot();
    var result = initial;

    for (0..2) |_| {
        state.symbols[@backingInt(iteration.condition_parameter)] = result;

        const version = state.current;

        _ = try state.expression(iteration.condition);

        if (!state.valid or state.current != version) {
            state.valid = false;

            return .none;
        }

        state.symbols[@backingInt(iteration.parameter)] = result;

        result = try state.expression(iteration.body);

        if (!state.valid or !state.retains(result, selected)) {
            state.valid = false;

            return .none;
        }
    }

    state.symbols[@backingInt(iteration.condition_parameter)] = result;

    const version = state.current;

    _ = try state.expression(iteration.condition);

    if (!state.valid or state.current != version) {
        state.valid = false;

        return .none;
    }

    state.symbols[@backingInt(iteration.condition_parameter)] = before.symbols[@backingInt(iteration.condition_parameter)];
    state.symbols[@backingInt(iteration.parameter)] = before.symbols[@backingInt(iteration.parameter)];

    return state.join(before, initial, result);
}
