const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const Prepared = @import("prepare.zig");
const SourceGraph = @import("source_graph.zig").Graph;
const State = @import("mixed/state.zig");

pub fn compile(graph: *Graph, backing: std.mem.Allocator, loaded: Prepared.Loaded, states: []const @import("constraints.zig").State, dependencies: SourceGraph, signatures: frontend.project.signature_project.Data, sources: []const frontend.project.Source, modules: []const rx.ModuleSource, exports: []const @import("../project.zig").Export, cache: *frontend.project.ParseCache, record: ?*@import("history.zig").History) zx.Error!Module.Value {
    const resolved = try @import("signatures.zig").resolve(graph, states);

    var state = State.init(graph.allocator, backing, dependencies, signatures, graph.types.items.view(), loaded.project) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = .{ .path = dependencies.modules[dependencies.entry].path, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "contract", .message = "source signatures cannot initialize the shared compilation context" } };
    };

    defer state.scratch.deinit();

    var entry: ?Module.Contract = null;
    var reuse = try @import("mixed/reuse.zig").begin(&state, cache, record);

    for (dependencies.order) |index| {
        const module = dependencies.modules[index];

        state.owner = index;

        if (try reuse.reuse(&state, index)) continue;

        switch (module.source) {
            .zx => {
                const signature = state.signature(index) orelse return .{ .diagnostic = .{ .path = module.path, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "source module signature is missing" } };

                if (signature.signature.has_store) {
                    reuse.analyzed(&state, index);

                    continue;
                }

                state.finished[index] = @import("mixed/zx.zig").compile(&state, cache, sources, index, null) catch |err| {
                    if (err == error.OutOfMemory) return error.OutOfMemory;

                    return .{ .diagnostic = state.issue.? };
                };

                reuse.analyzed(&state, index);
            },
            .rx => |source| {
                const result = @import("mixed/rx.zig").compile(&state, cache, sources, modules, index, loaded.modules[source], resolved[source]) catch |err| {
                    if (err == error.OutOfMemory) return error.OutOfMemory;

                    return .{ .diagnostic = state.issue.? };
                };

                state.finished[index] = result.loaded;

                if (index == dependencies.entry) entry = result.contract;

                reuse.analyzed(&state, index);
            },
        }
    }

    var contract = entry orelse return .{ .diagnostic = .{ .path = dependencies.modules[dependencies.entry].path, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "RX entry was not lowered" } };
    const id = state.finished[dependencies.entry].?.function.?;
    state.owner = dependencies.entry;

    const functions = if (exports.len == 0) state.functions.view().prefix(@backingInt(id)) else state.functions.view();

    contract.program = @import("mixed/function.zig").view(&state, id, functions) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = state.issue.? };
    };

    contract.types = state.types.items.view();
    contract.native_modules = state.native_modules.view();
    contract.nominal_types = state.types.origins.items.view();
    contract.input_type = contract.program.input_type;
    contract.output_type = contract.program.output_type;

    contract.exports = @import("mixed/exports.zig").collect(&state, exports) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = state.issue.? };
    };

    try reuse.finish(&state);

    return .{ .contract = contract };
}
