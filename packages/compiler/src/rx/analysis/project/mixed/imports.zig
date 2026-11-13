const std = @import("std");
const frontend = @import("frontend");
const zx = @import("zx");
const State = @import("state.zig");
const Binding = std.meta.Child(@FieldType(frontend.ResolvedImports, "imports"));
pub const Result = struct { functions: []const Binding, published: []const Binding };

pub fn collect(state: *State, header: anytype, index: usize, signature: frontend.project.signature_project.Module) State.Error!Result {
    var bindings: std.ArrayList(Binding) = .empty;
    var published: std.ArrayList(Binding) = .empty;

    try bindings.appendSlice(state.allocator, signature.function_imports);
    try published.appendSlice(state.allocator, signature.reexport_functions);

    const edges = state.graph.modules[index].dependencies;

    if (edges.len != header.importCount()) return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "source import declarations do not match the dependency graph");

    for (edges, 0..) |edge, import_index| {
        const item = header.importAt(import_index);

        if (item.kind == .type_only or edge.target == .native) continue;

        const dependency = switch (edge.target) {
            .source => |source| source_block: {
                const loaded = state.finished[source] orelse return state.fail(edge.location, "source function dependency has not been analyzed in its required context");

                break :source_block frontend.project.compiled.Export{ .name = "", .path = "", .function = loaded.function, .types = loaded.exports, .constants = loaded.constant_exports, .members = loaded.members };
            },
            .compiled => |target| try @import("library.zig").load(state, target, edge.location),
            .native => unreachable,
        };

        const temporary = state.scratch.allocator();
        const binding = frontend.project.import_binding;

        const own: ?Binding = if (dependency.function) |id| own: {
            const row = @backingInt(id);

            break :own .{ .name = "", .id = id, .input_type = @fromBackingInt(state.functions.input_types.items[row]), .output_type = @fromBackingInt(state.functions.output_types.items[row]) };
        } else null;

        const members: binding.Members = .{ .default = if (own) |*value| value else null, .named = dependency.members };
        const names = try members.names(temporary);
        const symbols = binding.Symbols{ .target = if (edge.target == .source) .source else .compiled, .types = state.types.items.view(), .exports = dependency.types, .constants = dependency.constants, .functions = names };
        var reporter: zx.Reporter = .{};
        const view = frontend.project.import_view.get(header, import_index);

        const selected = binding.select(temporary, state.allocator, view, &symbols, &reporter) catch |err| {
            if (err == error.OutOfMemory) return error.OutOfMemory;

            return state.fail(edge.location, reporter.diagnostic.?.message);
        };

        const destination = if (item.exported) &published else &bindings;

        for (selected.functions.names, selected.functions.indices) |name, selected_index| {
            var member = members.at(@intCast(selected_index)).*;
            member.name = try state.allocator.dupe(u8, name);

            try destination.append(state.allocator, member);
        }
    }

    return .{ .functions = bindings.items, .published = published.items };
}
