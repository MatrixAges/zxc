const std = @import("std");
const ir = @import("zx").ir;
const State = @import("../analysis.zig");
const facts = @import("../fact.zig");
const flow = @import("../../buffer_call/analysis/flow.zig");

pub fn evaluate(state: *State, id: ir.ExprId) std.mem.Allocator.Error!facts.Value {
    const expression = state.program.expression(id).value;
    const target_id = if (expression == .list_update) expression.list_update.target else expression.list_operation.target;
    const target = try state.expression(target_id);
    const child = state.program.typeOf(state.program.expression(target_id).type_id).list;
    const detached = flow.detached(state.program, child);
    var copied_alias = facts.contains(target);

    if (expression == .list_update) {
        const update = expression.list_update;

        state.observe(try state.expression(update.index));

        if (facts.contains(try state.expression(update.value))) state.valid = false;
    } else {
        const operation = expression.list_operation;

        for (operation.arguments) |argument| {
            const value = try state.expression(argument);

            state.observe(value);

            if (!facts.contains(value)) continue;
            if (operation.kind == .push) state.valid = false;

            copied_alias = true;
        }
    }

    state.observe(target);

    if (copied_alias and !detached) state.valid = false;
    if (!state.valid or expression == .list_update) return .none;

    const borrowed: facts.Value = switch (target) {
        .none => .none,
        .version, .borrowed => |version| .{ .borrowed = version },
        else => .stale,
    };

    const values: [2]facts.Value = switch (expression.list_operation.kind) {
        .pop => .{ borrowed, .none },
        .splice => .{ .none, borrowed },
        .push, .concat, .reverse, .sort => .{ .none, .none },
    };

    return .{ .aggregate = try state.allocator.dupe(facts.Value, &values) };
}
