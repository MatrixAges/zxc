const std = @import("std");
const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const States = @import("constraints.zig").States;

pub const Signature = struct {
    input_type: zx.ir.TypeId,
    output_type: zx.ir.TypeId,
    bindings: []const Module.Binding,
    tasks: []const zx.ir.TypeId,
};

pub fn resolve(allocator: std.mem.Allocator, graph: *Graph, states: States) zx.Error![]const Signature {
    const signatures = try allocator.alloc(Signature, states.len);

    for (signatures, 0..) |*signature, index| {
        const state = states.get(index);
        const bindings = try allocator.alloc(Module.Binding, state.bindings.len);

        for (state.bindings, bindings) |binding, *item| item.* = .{ .name = binding.name, .type_id = try graph.resolve(binding.value) };

        const tasks = try allocator.alloc(zx.ir.TypeId, state.tasks.len);

        for (state.tasks) |task| tasks[task.id] = try graph.resolve(task.output);

        signature.* = .{ .input_type = try graph.resolve(state.input), .output_type = try graph.resolve(state.output), .bindings = bindings, .tasks = tasks };
    }

    return signatures;
}
