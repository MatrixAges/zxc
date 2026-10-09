const frontend = @import("frontend");
const rx = @import("rx");
const State = @import("state.zig");
const Prepared = @import("../prepare.zig");
const Signature = @import("../signatures.zig").Signature;
const Module = @import("../../module.zig");
const Source = frontend.project.artifact.source_link;
pub const Result = struct { loaded: Source.Loaded, contract: ?Module.Contract };

pub fn compile(state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, modules: []const rx.ModuleSource, index: usize, module: Prepared.Module, signature: Signature) State.Error!Result {
    state.owner = index;

    const ids = try @import("callees.zig").load(state, cache, sources, modules, module);
    const entry = index == state.graph.entry;

    if (!entry) _ = state.scratch.reset(.retain_capacity);

    const allocator = if (entry) state.allocator else state.scratch.allocator();
    const base_view = state.functions.view();
    const base = try base_view.snapshot(allocator);
    const calls = try allocator.alloc(Module.Loaded, module.calls.len);

    for (module.calls, ids, calls) |call, id, *loaded| {
        loaded.* = .{
            .node = call.node,
            .getters = call.getters,
            .function = .{
                .id = id,
                .program = try @import("function.zig").view(state, id, base),
                .nominal_types = state.types.origins.items.view(),
                .store_initializers = state.initializers.items,
            },
        };
    }

    const result = try @import("../../module_compile.zig").compile(allocator, .{
        .owner = module.source.path,
        .module = module.source.node,
        .calls = calls,
        .steps = module.steps,
        .bindings = signature.bindings,
        .tasks = signature.tasks,
        .types = state.types.items.view(),
        .nominal_types = state.types.origins.items.view(),
        .native_modules = state.native_modules.view(),
        .shared_functions = base,
        .store_initializers = state.initializers.items,
        .input_type = signature.input_type,
        .output_type = signature.output_type,
    });

    if (result == .diagnostic) {
        const copied = try @import("../../call/target.zig").failure(state.allocator, result.diagnostic);

        state.issue = copied.diagnostic;

        return error.InvalidSourceGraph;
    }

    var contract = result.contract;

    if (entry) try @import("metadata.zig").retain(state.allocator, &contract);

    var destination = state.destination();

    destination.temporary = allocator;

    const loaded = Source.appendBody(.{
        .program = contract.program,
        .base_functions = base_view,
        .nominal_types = contract.nominal_types,
        .store_initializers = contract.store_initializers,
    }, destination) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return state.fail(module.source.node.location, "RX module body cannot be linked to its shared compilation context");
    };

    if (!entry) return .{ .loaded = loaded, .contract = null };

    contract.program = try @import("function.zig").view(state, loaded.function.?, state.functions.view());
    contract.types = state.types.items.view();
    contract.nominal_types = state.types.origins.items.view();
    contract.native_modules = state.native_modules.view();
    contract.store_initializers = loaded.store_initializers;

    return .{ .loaded = loaded, .contract = contract };
}
