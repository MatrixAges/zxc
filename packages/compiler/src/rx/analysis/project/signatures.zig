const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const State = @import("constraints.zig").State;

pub const Signature = struct {
    input_type: zx.ir.TypeId,
    output_type: zx.ir.TypeId,
    bindings: []const Module.Binding,
    tasks: []const @import("../flow_compile.zig").TaskType,
};

pub fn resolve(graph: *Graph, states: []const State) zx.Error![]const Signature {
    const signatures = try graph.allocator.alloc(Signature, states.len);

    for (states, signatures) |state, *signature| {
        const bindings = try graph.allocator.alloc(Module.Binding, state.bindings.len);

        for (state.bindings, bindings) |binding, *item| item.* = .{ .name = binding.name, .type_id = try graph.resolve(binding.value) };

        const tasks = try graph.allocator.alloc(@import("../flow_compile.zig").TaskType, state.tasks.len);

        for (state.tasks, tasks) |task, *resolved| resolved.* = .{ .id = task.id, .output_type = try graph.resolve(task.output) };

        signature.* = .{ .input_type = try graph.resolve(state.input), .output_type = try graph.resolve(state.output), .bindings = bindings, .tasks = tasks };
    }

    return signatures;
}
