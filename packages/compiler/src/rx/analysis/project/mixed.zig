const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const Prepared = @import("prepare.zig");
const SourceGraph = @import("source_graph.zig").Graph;
const State = @import("mixed/state.zig");

pub fn compile(graph: *Graph, loaded: Prepared.Loaded, states: []const @import("constraints.zig").State, dependencies: SourceGraph, signatures: frontend.project.signature_project.Data, sources: []const frontend.project.Source, modules: []const rx.ModuleSource) zx.Error!Module.Value {
    const resolved = try @import("signatures.zig").resolve(graph, states);

    var state = State.init(graph.allocator, dependencies, signatures, graph.types.items.view(), loaded.project) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = .{ .path = dependencies.modules[dependencies.entry].path, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "contract", .message = "source signatures cannot initialize the shared compilation context" } };
    };

    defer state.scratch.deinit();

    var cache = frontend.project.ParseCache{ .allocator = graph.allocator };

    defer cache.deinit();

    var entry: ?Module.Contract = null;

    for (dependencies.order) |index| {
        const module = dependencies.modules[index];

        state.owner = index;

        switch (module.source) {
            .zx => {
                const signature = state.signature(index) orelse return .{ .diagnostic = .{ .path = module.path, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "source module signature is missing" } };

                if (signature.signature.has_store) continue;

                state.finished[index] = @import("mixed/zx.zig").compile(&state, &cache, sources, index, null) catch |err| {
                    if (err == error.OutOfMemory) return error.OutOfMemory;

                    return .{ .diagnostic = state.issue.? };
                };
            },
            .rx => |source| {
                const result = @import("mixed/rx.zig").compile(&state, &cache, sources, modules, index, loaded.modules[source], resolved[source]) catch |err| {
                    if (err == error.OutOfMemory) return error.OutOfMemory;

                    return .{ .diagnostic = state.issue.? };
                };

                state.finished[index] = result.loaded;

                if (index == dependencies.entry) entry = result.contract;
            },
        }
    }

    var contract = entry orelse return .{ .diagnostic = .{ .path = dependencies.modules[dependencies.entry].path, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "RX entry was not lowered" } };
    const id = state.finished[dependencies.entry].?.function.?;
    state.owner = dependencies.entry;

    contract.program = @import("mixed/function.zig").view(&state, id, state.functions.view().prefix(@backingInt(id))) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = state.issue.? };
    };

    contract.types = state.types.items.view();
    contract.native_modules = state.native_modules.view();
    contract.nominal_types = state.types.origins.items.view();
    contract.input_type = contract.program.input_type;
    contract.output_type = contract.program.output_type;

    return .{ .contract = contract };
}
