const std = @import("std");
const zx = @import("zx");
const generated = @import("genz_options").generated_analysis;
const entry = if (generated) @import("generated_iteration_initial") else struct {};
const Representation = @import("../iteration_layout/select.zig").Representation;
const Mode = @import("result.zig").Mode;
const ParameterLayout = @import("parameters.zig").Layout;

pub const Request = struct {
    representation: Representation,
    mode: Mode,
    state_active: bool,
    direct_initial: bool,
    postcondition: bool,
    consumer: bool,
    pure: bool,
    forwarded: bool,
};

const Plan = if (generated) std.meta.Child(entry.Output) else struct {
    parameters: ParameterLayout,
    layout: bool,
    selected_state: bool,
    deep: bool,
    buffered: bool,
    evaluation: enum { Reference, Value, Deep },
    local: bool,
    by_value: bool,
    project_fields: bool,
    track: bool,
    guard: enum { None, Unit, Consumer },
    state_scope: bool,
    storage: enum { Keep, Dereference, Deep, State, StateValue, Clip },
};

pub const Guard = @FieldType(Plan, "guard");

pub fn plan(request: Request) Plan {
    if (comptime !generated) return seed(request);

    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .representation = switch (request.representation) {
            .plain => .Plain,
            .stack => .Stack,
            .state => .State,
            .deep => .Deep,
            .buffered => .Buffered,
            .dereference, .reject => unreachable,
        },
        .mode = switch (request.mode) {
            .reference => .Reference,
            .value => .Value,
            .discard => .Discard,
            .consume => .Consume,
        },
        .state_active = request.state_active,
        .direct_initial = request.direct_initial,
        .postcondition = request.postcondition,
        .consumer = request.consumer,
        .pure = request.pure,
        .forwarded = request.forwarded,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const result = zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch unreachable;

    return .{
        .parameters = result.parameters,
        .layout = result.layout,
        .selected_state = result.selected_state,
        .deep = result.deep,
        .buffered = result.buffered,
        .evaluation = result.evaluation,
        .local = result.local,
        .by_value = result.by_value,
        .project_fields = result.project_fields,
        .track = result.track,
        .guard = result.guard,
        .state_scope = result.state_scope,
        .storage = result.storage,
    };
}

fn seed(input: Request) Plan {
    const parameters: ParameterLayout = switch (input.representation) {
        .plain => .Plain,
        .stack => .Stack,
        .state => .State,
        .deep, .buffered => .Deep,
        .dereference, .reject => unreachable,
    };

    const selected_state = parameters == .State;
    const layout = selected_state or parameters == .Stack;
    const deep = parameters == .Deep;
    const buffered = input.representation == .buffered;
    const by_value = layout and input.mode != .reference;
    const local = layout or deep;

    const storage: @FieldType(Plan, "storage") = if (selected_state)
        if (input.state_active) .Clip else if (by_value) .StateValue else .State

    else if (by_value or input.direct_initial)
        .Keep
    else if (deep)
        .Deep
    else if (layout)
        .Dereference
    else
        .Keep;

    return .{
        .parameters = parameters,
        .layout = layout,
        .selected_state = selected_state,
        .deep = deep,
        .buffered = buffered,
        .evaluation = if (input.direct_initial) .Deep else if (by_value) .Value else .Reference,
        .local = local,
        .by_value = by_value,
        .project_fields = selected_state and input.pure and !input.forwarded,
        .track = local and !by_value and input.mode != .discard,
        .guard = if (buffered and !input.postcondition) if (input.consumer) .Consumer else .Unit else .None,
        .state_scope = storage == .State or storage == .StateValue,
        .storage = storage,
    };
}
