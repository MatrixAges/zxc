const std = @import("std");
const zx = @import("zx");
const generated = @import("genz_options").generated_analysis;
const entry = if (generated) @import("generated_iteration_initial") else struct {};

pub const Input = if (generated) std.meta.Child(entry.Input) else struct {
    layout: bool,
    selected_state: bool,
    state_active: bool,
    deep: bool,
    buffered: bool,
    direct_initial: bool,
    postcondition: bool,
    reference: bool,
    discard: bool,
    pure: bool,
    forwarded: bool,
};

const Plan = if (generated) std.meta.Child(entry.Output) else struct {
    evaluation: enum { Reference, Value, Deep },
    local: bool,
    by_value: bool,
    project_fields: bool,
    track: bool,
    guard: bool,
    storage: enum { Keep, Dereference, Deep, State, StateValue, Clip },
};

pub fn plan(input: Input) Plan {
    if (comptime !generated) return seed(input);

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const result = zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch unreachable;

    return .{
        .evaluation = result.evaluation,
        .local = result.local,
        .by_value = result.by_value,
        .project_fields = result.project_fields,
        .track = result.track,
        .guard = result.guard,
        .storage = result.storage,
    };
}

fn seed(input: Input) Plan {
    const by_value = input.layout and !input.reference;
    const local = input.layout or input.deep;

    const storage: @FieldType(Plan, "storage") = if (input.selected_state)
        if (input.state_active) .Clip else if (by_value) .StateValue else .State

    else if (by_value or input.direct_initial)
        .Keep
    else if (input.deep)
        .Deep
    else if (input.layout)
        .Dereference
    else
        .Keep;

    return .{
        .evaluation = if (input.direct_initial) .Deep else if (by_value) .Value else .Reference,
        .local = local,
        .by_value = by_value,
        .project_fields = input.selected_state and input.pure and !input.forwarded,
        .track = local and !by_value and !input.discard,
        .guard = input.buffered and !input.postcondition,
        .storage = storage,
    };
}
