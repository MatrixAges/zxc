const std = @import("std");
const ir = @import("zx").ir;
const State = @import("../analysis.zig");
const facts = @import("../fact.zig");

pub fn evaluate(state: *State, iteration: ir.Iteration) std.mem.Allocator.Error!facts.Value {
    var head = try state.expression(iteration.initial);
    const before = try state.snapshot();
    const serial = state.serial;

    defer state.restore(before);

    while (state.valid) {
        state.restore(before);
        state.symbols[@backingInt(iteration.condition_parameter)] = head;
        state.observe(try state.expression(iteration.condition));
        state.restore(before);
        state.symbols[@backingInt(iteration.parameter)] = head;

        const result = try state.expression(iteration.body);

        if (state.current != before.current or state.serial != serial) state.valid = false;
        if (!state.valid) return .none;

        const next = try facts.merge(state.allocator, head, result, before.current, before.current, before.current);

        if (facts.equal(head, next)) return next;

        head = next;
    }

    return .none;
}
