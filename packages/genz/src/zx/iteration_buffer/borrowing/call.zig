const std = @import("std");
const ir = @import("zx").ir;
const State = @import("../analysis.zig");
const facts = @import("../fact.zig");
const statements = @import("../statements.zig");

pub fn evaluate(state: *State, id: ir.ExprId, argument: facts.Value) std.mem.Allocator.Error!facts.Value {
    if (!facts.contains(argument)) return .none;

    state.observe(argument);

    const call = state.program.expression(id).value.call;
    const index = @backingInt(call.function);

    if (!state.valid or index >= state.program.functions.count() or call.stores.len != 0) {
        state.valid = false;

        return .none;
    }

    const function = state.program.functions.at(index);

    if (function.external != null or function.stores.count() != 0 or function.contracts.count() != 0) {
        state.valid = false;

        return .none;
    }

    if (state.calls) |calls| {
        if (index >= calls.summaries.len) {
            state.valid = false;

            return .none;
        }

        if (index < calls.readers.len and calls.readers[index]) return .none;

        for (calls.summaries[index]) |lane| {
            if (lane.rejection != null or (lane.appends.len == 0 and lane.pops.len == 0 and lane.updates.len == 0 and lane.calls.len == 0)) continue;

            var source = argument;

            for (lane.input) |part| source = facts.field(source, part);

            if (facts.contains(source)) {
                state.valid = false;

                return .none;
            }
        }
    }

    var program = state.program;

    program.input_type = function.input_type;
    program.output_type = function.output_type;
    program.symbols = function.symbols;
    program.expressions = function.expressions;
    program.body = function.body;
    program.functions = program.functions.prefix(index);

    var child = State{
        .allocator = state.allocator,
        .program = program,
        .symbols = try State.Symbols.init(state.allocator, program.symbols.count()),
        .cached = try State.Cached.init(state.allocator, program.expressions.count()),
        .current = state.current,
        .serial = state.serial,
        .borrowing = true,
        .calls = if (state.calls) |calls| .{ .selected = &.{}, .summaries = calls.summaries[0..index], .readers = calls.readers[0..@min(index, calls.readers.len)] } else null,
    };

    try child.symbols.set(child.allocator, 0, argument);

    var results: std.ArrayList(statements.Result) = .empty;
    const returns = try statements.evaluate(&child, program.body.block(), &results);

    if (!returns or !child.valid or child.serial != state.serial or results.items.len == 0) {
        state.valid = false;

        return .none;
    }

    var result = results.items[0].value;

    for (results.items, 0..) |returned, position| {
        if (returned.version != state.current) state.valid = false;
        if (position != 0) result = try facts.merge(state.allocator, result, returned.value, state.current, state.current, state.current);
    }

    return result;
}
