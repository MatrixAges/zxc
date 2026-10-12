const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const ir = @import("zx").ir;
const State = @import("state.zig");
const Loading = @import("../prepare.zig");
const Signature = @import("../signatures.zig").Signature;
const Module = @import("../../module.zig");
const Source = frontend.project.artifact.source_link;
pub const Result = struct { loaded: Source.Loaded, contract: ?Module.Contract };

/// A module ready for lowering: the functions its calls bind, which the shared tables already hold, and the extent of
/// the tables it is lowered against.
pub const Prepared = struct {
    index: usize,
    module: Loading.Module,
    signature: Signature,
    base: ir.FunctionTable,
    calls: []const Module.Loaded,
    functions: usize,
    types: usize,
    native_modules: usize,
    initializers: usize,
};

pub fn compile(state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, modules: []const rx.ModuleSource, index: usize, module: Loading.Module, signature: Signature) State.Error!Result {
    state.owner = index;

    const ids = try @import("callees.zig").load(state, cache, sources, modules, module);
    const entry = index == state.graph.entry;

    if (!entry) _ = state.scratch.reset(.retain_capacity);

    const allocator = if (entry) state.allocator else state.scratch.allocator();
    const prepared = try prepare(state, allocator, index, module, signature, ids);
    const result = try lower(state, allocator, prepared);

    if (result == .diagnostic) {
        const copied = try @import("../../call/target.zig").failure(state.allocator, result.diagnostic);

        state.issue = copied.diagnostic;

        return error.InvalidSourceGraph;
    }

    return link(state, allocator, prepared, result.contract);
}

/// Binds the calls of `module` to the functions `ids` names, over the shared tables as they stand.
pub fn prepare(state: *State, allocator: std.mem.Allocator, index: usize, module: Loading.Module, signature: Signature, ids: []const ir.FunctionId) State.Error!Prepared {
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

    return .{ .index = index, .module = module, .signature = signature, .base = base, .calls = calls, .functions = base_view.count(), .types = state.types.items.count(), .native_modules = state.native_modules.count(), .initializers = state.initializers.items.len };
}

/// Lowers a prepared module against the shared tables, which it only reads, so modules that depend on none of each
/// other may lower at once.
pub fn lower(state: *const State, allocator: std.mem.Allocator, prepared: Prepared) std.mem.Allocator.Error!Module.Value {
    return @import("../../module_compile.zig").compile(allocator, .{
        .owner = prepared.module.source.path,
        .module = prepared.module.source.node,
        .calls = prepared.calls,
        .steps = prepared.module.steps,
        .bindings = prepared.signature.bindings,
        .tasks = prepared.signature.tasks,
        .types = state.types.items.view(),
        .nominal_types = state.types.origins.items.view(),
        .native_modules = state.native_modules.view(),
        .shared_functions = prepared.base,
        .verified_functions = state.verifiedFunctions(),
        .store_initializers = state.initializers.items,
        .input_type = prepared.signature.input_type,
        .output_type = prepared.signature.output_type,
    });
}

/// Whether a module lowered earlier can still be linked as it is: the tables it read may only have gained types, and
/// functions when it adds none of its own.
pub fn current(state: *const State, prepared: Prepared, contract: Module.Contract) bool {
    if (state.native_modules.count() != prepared.native_modules or state.initializers.items.len != prepared.initializers) return false;

    return contract.program.functions.count() == prepared.functions or state.functions.count() == prepared.functions;
}

/// Links a lowered module. The tables may have grown, and moved, since it was lowered, but the rows it read are
/// unchanged, so the module refers to them where they are now.
pub fn link(state: *State, allocator: std.mem.Allocator, prepared: Prepared, lowered: Module.Contract) State.Error!Result {
    const entry = prepared.index == state.graph.entry;
    var contract = lowered;

    if (entry) try @import("metadata.zig").retain(state.allocator, &contract);

    var destination = state.destination();

    destination.temporary = allocator;
    const grown = state.functions.count() != prepared.functions or state.types.items.count() != prepared.types;

    const loaded = state.linked(Source.appendBody(.{
        .program = contract.program,
        .base_functions = state.functions.view().prefix(prepared.functions),
        .verified_functions = state.verifiedFunctions(),
        .nominal_types = contract.nominal_types,
        .store_initializers = contract.store_initializers,
        .base_types = if (grown) prepared.types else null,
    }, destination) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return state.fail(prepared.module.source.node.location, "RX module body cannot be linked to its shared compilation context");
    });

    if (!entry) return .{ .loaded = loaded, .contract = null };

    contract.program = try @import("function.zig").view(state, loaded.function.?, state.functions.view());
    contract.types = state.types.items.view();
    contract.nominal_types = state.types.origins.items.view();
    contract.native_modules = state.native_modules.view();
    contract.store_initializers = loaded.store_initializers;

    return .{ .loaded = loaded, .contract = contract };
}
