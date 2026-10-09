const std = @import("std");
const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const Prepared = @import("prepare.zig");
const State = @import("constraints.zig").State;

pub fn compile(graph: *Graph, loaded: Prepared.Loaded, states: []const State, order: []const usize, entry: usize) zx.Error!Module.Value {
    const allocator = graph.allocator;
    const signatures = try @import("signatures.zig").resolve(graph, states);
    const contracts = try allocator.alloc(?Module.Contract, states.len);

    @memset(contracts, null);

    var types: zx.ir.TypeTable = graph.types.items.view();

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
                    .signature => return graph.reporter.fail(.module, graph.nodes.items[@backingInt(states[index].input)].span, "source function bodies must be analyzed before RX lowering"),
                    .module => |module_index| .{ .program = contracts[module_index].?.program, .store_initializers = contracts[module_index].?.store_initializers, .nominal_types = loaded.project.context.nominal_types },
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
            .native_modules = loaded.project.context.native_modules,
            .input_type = signature.input_type,
            .output_type = signature.output_type,
        });

        if (result == .diagnostic) return result;

        contracts[index] = result.contract;
        types = result.contract.types;
    }

    return .{ .contract = contracts[entry].? };
}
