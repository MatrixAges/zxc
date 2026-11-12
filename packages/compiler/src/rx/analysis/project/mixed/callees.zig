const frontend = @import("frontend");
const ir = @import("zx").ir;
const State = @import("state.zig");
const Prepared = @import("../prepare.zig");

pub fn load(state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, module: Prepared.Module) State.Error![]const ir.FunctionId {
    const owner = state.owner;
    const ids = try state.allocator.alloc(ir.FunctionId, module.calls.len);

    for (module.calls, ids) |call, *id| {
        const location = call.node.location;

        id.* = switch (call.edge.target) {
            .compiled => |library| block: {
                const exported = try @import("library.zig").load(state, library, location);
                const function = exported.function orelse return state.fail(location, "Call.module requires an executable public module");
                const value = state.functions.at(@backingInt(function));

                if (call.setter != null or (value.stores.count() != 0 and value.store_mode != .orchestration)) return state.fail(location, "compiled Store transactions require an explicit authorized RX module");

                break :block function;
            },
            .source => |index| block: {
                const is_rx = state.graph.modules[index].source == .rx;

                const loaded = if (call.setter != null and !is_rx)
                    try @import("zx.zig").compile(state, cache, sources, index, call.setter)
                else
                    state.finished[index] orelse return state.fail(location, if (is_rx) "RX call target has not been lowered" else "source call target has not been analyzed in its required context");

                state.owner = owner;

                break :block loaded.function orelse return state.fail(location, if (is_rx) "Call.module requires an executable source module" else "Call requires an executable source module");
            },
            .native => unreachable,
        };
    }

    return ids;
}

/// Whether every call of `module` binds a source function the shared tables already hold, so loading them changes
/// nothing: no compiled library to load and no Store setter to analyze.
pub fn local(module: Prepared.Module) bool {
    for (module.calls) |call| {
        if (call.setter != null or call.edge.target != .source) return false;
    }

    return true;
}
