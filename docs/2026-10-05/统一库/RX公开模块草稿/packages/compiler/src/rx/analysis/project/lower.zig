const std = @import("std");
const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const SourceMap = @import("../source_map.zig");
const Prepared = @import("prepare.zig");
const State = @import("constraints.zig").State;
const Signature = struct { input_type: zx.ir.TypeId, output_type: zx.ir.TypeId, bindings: []const Module.Binding };

pub fn compile(graph: *Graph, loaded: Prepared.Loaded, states: []const State, order: []const usize, source_map: SourceMap, entry: usize) zx.Error!Module.Value {
    const allocator = graph.allocator;
    const signatures = try allocator.alloc(Signature, states.len);
    const contracts = try allocator.alloc(?Module.Contract, states.len);

    @memset(contracts, null);

    for (states, signatures, loaded.modules, 0..) |state, *signature, module, index| {
        const bindings = try allocator.alloc(Module.Binding, state.bindings.len);

        for (state.bindings, bindings) |binding, *item| item.* = .{ .name = binding.name, .type_id = try graph.resolve(binding.value) };

        var binding_index: usize = 0;

        for (module.calls) |call| {
            for (call.node.attributes) |attribute| {
                if (!std.mem.eql(u8, attribute.name, "out")) continue;

                const type_id = bindings[binding_index].type_id;

                binding_index += 1;

                if (type_id == @as(zx.ir.TypeId, @enumFromInt(@intFromEnum(zx.ir.Scalar.void)))) {
                    const offset = source_map.base(index) + attribute.value_location.offset;

                    return graph.reporter.fail(.type_mismatch, .{ .start = offset, .end = offset }, "void call results cannot be bound");
                }
            }
        }

        signature.* = .{ .input_type = try graph.resolve(state.input), .output_type = try graph.resolve(state.output), .bindings = bindings };
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
