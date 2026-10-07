const std = @import("std");
const ir = @import("zx").ir;
const State = @import("analysis.zig");
const facts = @import("fact.zig");
const Error = std.mem.Allocator.Error;
pub const Result = struct { value: facts.Value, version: usize };

pub fn evaluate(state: *State, statements: ir.Block, results: *std.ArrayList(Result)) Error!bool {
    for (0..statements.len) |statement_index| {
        const statement = statements.at(statement_index);

        if (!state.valid) return true;

        switch (statement) {
            .evaluate => |id| _ = try state.expression(id),
            .constant => |binding| state.symbols[@backingInt(binding.symbol)] = try state.expression(binding.value),
            .destructure => |binding| {
                const value = try state.expression(binding.value);

                for (0..binding.symbols.len) |index| {
                    const symbol = binding.symbols.at(index);

                    if (symbol) |id| {
                        state.symbols[@backingInt(id)] = facts.field(value, @intCast(index));
                    }
                }
            },
            .result => |id| {
                const value = if (id) |value| try state.expression(value) else facts.Value.none;

                try results.append(state.allocator, .{ .value = value, .version = state.current });

                return true;
            },
            .branch => |branch| {
                state.observe(try state.expression(branch.condition));

                const before = try state.snapshot();
                const yes_returns = try evaluate(state, branch.yes, results);
                const yes = try state.snapshot();

                state.restore(before);

                const no_returns = try evaluate(state, branch.no, results);

                if (yes_returns and no_returns) return true;
                if (!yes_returns and no_returns) state.restore(yes);
                if (!yes_returns and !no_returns) _ = try state.join(yes, .none, .none);
            },
            .switch_stmt => |selection| {
                state.observe(try state.expression(selection.subject));

                const before = try state.snapshot();
                var combined: ?@TypeOf(before) = if (selection.exhaustive) null else before;

                for (0..selection.cases.len) |case_index| {
                    const case = selection.cases.at(case_index);

                    state.restore(before);

                    if (try evaluate(state, case.body, results)) continue;
                    if (combined) |previous| _ = try state.join(previous, .none, .none);

                    combined = try state.snapshot();
                }

                if (combined) |remaining| state.restore(remaining) else return true;
            },
            .store_set, .parallel => {
                state.valid = false;

                return true;
            },
        }
    }

    return false;
}
