const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const ir = @import("zx").ir;
const State = @import("state.zig");
const Prepared = @import("../prepare.zig");

pub fn load(state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, modules: []const rx.ModuleSource, module: Prepared.Module) State.Error![]const ir.FunctionId {
    const owner = state.owner;
    const ids = try state.allocator.alloc(ir.FunctionId, module.calls.len);

    for (module.calls, ids) |call, *id| {
        const reference = try @import("../reference.zig").resolve(state.allocator, module.source.path, call.node, modules, state.options);
        const location = call.node.location;

        id.* = switch (reference) {
            .diagnostic => |issue| {
                state.issue = issue;

                return error.InvalidSourceGraph;
            },
            .compiled => |library| block: {
                const exported = try @import("library.zig").load(state, library, location);
                const function = exported.function orelse return state.fail(location, "Call.module requires an executable public module");
                const value = state.functions.at(@backingInt(function));

                if (call.setter != null or (value.stores.count() != 0 and value.store_mode != .orchestration)) return state.fail(location, "compiled Store transactions require an explicit authorized RX module");

                break :block function;
            },
            .source => |path| block: {
                const index = find(state, path) orelse return state.fail(location, "source call target is missing from the dependency graph");

                const loaded = if (call.setter) |setter|
                    try @import("zx.zig").compile(state, cache, sources, index, setter)
                else
                    state.finished[index] orelse return state.fail(location, "source call target has not been analyzed in its required context");

                state.owner = owner;

                break :block loaded.function orelse return state.fail(location, "Call requires an executable source module");
            },
            .module => |index| block: {
                const path = try std.fs.path.resolve(state.allocator, &.{ state.options.root_dir, modules[index].path });
                const source = find(state, path) orelse return state.fail(location, "RX call target is missing from the dependency graph");
                const loaded = state.finished[source] orelse return state.fail(location, "RX call target has not been lowered");

                break :block loaded.function orelse return state.fail(location, "Call.module requires an executable source module");
            },
        };
    }

    return ids;
}

fn find(state: *const State, path: []const u8) ?usize {
    for (state.graph.modules, 0..) |module, index| {
        if (std.mem.eql(u8, module.path, path)) return index;
    }

    return null;
}
