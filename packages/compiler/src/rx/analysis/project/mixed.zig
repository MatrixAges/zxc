const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("../module.zig");
const Frame = @import("history.zig").Frame;
const State = @import("mixed/state.zig");

/// Analyzes and links every module in dependency order over the shared tables `derived` starts them from.
pub fn compile(allocator: std.mem.Allocator, backing: std.mem.Allocator, derived: Frame, selected: []const rx.ModuleSource, sources: []const frontend.project.Source, exports: []const @import("../project.zig").Export, cache: *frontend.project.ParseCache, record: ?*@import("history.zig").History) std.mem.Allocator.Error!Module.Value {
    const dependencies = derived.dependencies;
    const loaded = derived.loaded;
    const resolved = derived.resolved;
    const modules = derived.modules;

    var state = State.init(allocator, backing, dependencies, derived.signatures, derived.types, loaded.project) catch |err| {
        if (err == error.OutOfMemory) return error.OutOfMemory;

        return .{ .diagnostic = .{ .path = dependencies.modules[dependencies.entry].path, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "contract", .message = "source signatures cannot initialize the shared compilation context" } };
    };

    defer state.scratch.deinit();

    var entry: ?Module.Contract = null;
    var reuse = try @import("mixed/reuse.zig").begin(&state, cache, record, derived);
    var ahead = try @import("mixed/ahead.zig").init(allocator, dependencies.modules.len);

    defer ahead.deinit();

    const depths = try @import("source_graph/order.zig").depth(allocator, dependencies.modules, dependencies.order);
    var start: usize = 0;

    for (dependencies.order, 0..) |index, position| {
        const module = dependencies.modules[index];

        if (position == start) {
            var end = start + 1;

            while (end < dependencies.order.len and depths[dependencies.order[end]] == depths[index]) end += 1;

            try ahead.analyze(&state, cache, sources, derived, &reuse, dependencies.order[start..end]);

            start = end;
        }

        state.owner = index;

        if (try reuse.reuse(&state, index)) continue;

        switch (module.source) {
            .zx => {
                const signature = state.signature(index) orelse return .{ .diagnostic = .{ .path = module.path, .location = .{ .offset = 0, .line = 1, .column = 1 }, .code = "module", .message = "source module signature is missing" } };

                if (signature.signature.has_store) {
                    reuse.analyzed(&state, index);

                    continue;
                }

                const zx_module = @import("mixed/zx.zig");

                const body = if (ahead.take(&state, index)) |analyzed| linked: {
                    _ = state.scratch.reset(.retain_capacity);

                    break :linked zx_module.link(&state, state.scratch.allocator(), analyzed);
                } else zx_module.compile(&state, cache, sources, index, null);

                state.finished[index] = body catch |err| {
                    if (err == error.OutOfMemory) return error.OutOfMemory;

                    return .{ .diagnostic = state.issue.? };
                };

                reuse.analyzed(&state, index);
            },
            .rx => |source| {
                const rx_module = @import("mixed/rx.zig");

                const linked = if (ahead.lowered(&state, index)) |lowered| ready: {
                    _ = state.scratch.reset(.retain_capacity);

                    break :ready rx_module.link(&state, state.scratch.allocator(), lowered.prepared, lowered.contract);
                } else rx_module.compile(&state, cache, sources, modules, index, loaded.modules[source], resolved[source]);

                const result = linked catch |err| {
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

    try reuse.finish(&state, derived, selected, sources);

    return .{ .contract = contract };
}
