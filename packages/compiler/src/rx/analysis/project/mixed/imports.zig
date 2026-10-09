const std = @import("std");
const frontend = @import("frontend");
const State = @import("state.zig");
const Binding = std.meta.Child(@FieldType(frontend.ResolvedImports, "imports"));

pub fn collect(state: *State, header: anytype, index: usize, signature: frontend.project.signature_project.Module) State.Error![]const Binding {
    var bindings: std.ArrayList(Binding) = .empty;

    try bindings.appendSlice(state.allocator, signature.function_imports);

    const edges = state.graph.modules[index].dependencies;

    if (edges.len != header.importCount()) return state.fail(.{ .offset = 0, .line = 1, .column = 1 }, "source import declarations do not match the dependency graph");

    for (edges, 0..) |edge, import_index| {
        const item = header.importAt(import_index);

        if (item.kind != .function or edge.target == .native) continue;
        if (header.importNameCount(import_index) != 1) return state.fail(edge.location, "default imports require one binding");

        const id = switch (edge.target) {
            .source => |source| block: {
                const loaded = state.finished[source] orelse return state.fail(edge.location, "source function dependency has not been analyzed in its required context");

                break :block loaded.function orelse return state.fail(edge.location, "default imports must refer to an executable module");
            },
            .compiled => |target| (try @import("library.zig").load(state, target, edge.location)).function orelse return state.fail(edge.location, "default imports must refer to an executable module"),
            .native => unreachable,
        };

        const function = state.functions.at(@backingInt(id));

        try bindings.append(state.allocator, .{
            .name = try state.allocator.dupe(u8, header.importNameAt(import_index, 0).text),
            .id = id,
            .input_type = function.input_type,
            .output_type = function.output_type,
        });
    }

    return bindings.items;
}
