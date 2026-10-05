const std = @import("std");
const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const Prepared = @import("prepare.zig");
const State = @import("constraints.zig").State;
const Signature = struct { input_type: zx.ir.TypeId, output_type: zx.ir.TypeId, bindings: []const Module.Binding, tasks: []const @import("../flow_compile.zig").TaskType };

pub fn compile(graph: *Graph, loaded: Prepared.Loaded, states: []const State, order: []const usize, entry: usize) zx.Error!Module.Value {
    const allocator = graph.allocator;
    const signatures = try allocator.alloc(Signature, states.len);
    const contracts = try allocator.alloc(?Module.Contract, states.len);

    @memset(contracts, null);

    for (states, signatures) |state, *signature| {
        const bindings = try allocator.alloc(Module.Binding, state.bindings.len);

        for (state.bindings, bindings) |binding, *item| item.* = .{ .name = binding.name, .type_id = try graph.resolve(binding.value) };

        const tasks = try allocator.alloc(@import("../flow_compile.zig").TaskType, state.tasks.len);

        for (state.tasks, tasks) |task, *resolved| resolved.* = .{ .id = task.id, .output_type = try graph.resolve(task.output) };

        signature.* = .{ .input_type = try graph.resolve(state.input), .output_type = try graph.resolve(state.output), .bindings = bindings, .tasks = tasks };
    }

    var types: []const zx.ir.Type = graph.types.items.items;

    for (order) |index| {
        const module = loaded.modules[index];
        const signature = signatures[index];
        const calls = try allocator.alloc(Module.Loaded, module.calls.len);

        for (module.calls, calls) |call, *item| {
            item.* = .{
                .node = call.node,
                .getters = call.getters,
                .function = switch (call.callee) {
                    .function => |function| function,
                    .service => |service| .{ .program = contracts[service].?.program, .store_initializers = contracts[service].?.store_initializers, .nominal_types = loaded.project.context.nominal_types },
                },
            };
        }

        const result = try @import("../module_compile.zig").compile(allocator, .{
            .owner = module.source.path,
            .module = module.source.node,
            .calls = calls,
            .steps = module.steps,
            .bindings = signature.bindings,
            .tasks = signature.tasks,
            .types = types,
            .nominal_types = loaded.project.context.nominal_types,
            .input_type = signature.input_type,
            .output_type = signature.output_type,
        });

        if (result == .diagnostic) return result;

        contracts[index] = result.contract;
        types = result.contract.types;
    }

    return .{ .contract = contracts[entry].? };
}
