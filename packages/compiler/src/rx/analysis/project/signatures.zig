const std = @import("std");
const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const Ports = @import("constraints.zig").Ports;
const Requests = @import("signatures/requests.zig");
const generated = @import("rx_options").generated_graph;
const rule = if (generated) @import("generated_rx_signature_publish") else void;

pub const Signature = struct {
    input_type: zx.ir.TypeId,
    output_type: zx.ir.TypeId,
    bindings: Module.Bindings,
    tasks: []const zx.ir.TypeId,
};

pub fn resolve(allocator: std.mem.Allocator, graph: *Graph, ports: Ports, requests: Requests) zx.Error![]const Signature {
    if (ports.len == 0) return &.{};

    const signatures = try allocator.alloc(Signature, ports.len);
    const task_types = try allocator.alloc(u32, requests.tasks.len);
    const bindings = requests.bindings.slice();
    const names = bindings.items(.name);
    const binding_types: []u32 = @ptrCast(bindings.items(.value));
    const tasks = requests.tasks.slice();
    const inputs: []u32 = @ptrCast(ports.items(.input));
    const outputs: []u32 = @ptrCast(ports.items(.output));
    const binding_ends = ports.items(.binding_end);
    const task_ends = ports.items(.task_end);

    if (comptime generated and @bitSizeOf(usize) == 64) {
        const Input = std.meta.Child(rule.Input);
        const rows = graph.nodes.slice();
        const parents = graph.forest.state.items;

        const nodes: std.meta.Child(@FieldType(Input, "nodes")) = .{
            .parents = @ptrCast(&parents),
            .kinds = rows.items(.kind),
            .arguments = rows.items(.argument),
        };

        const ranges: std.meta.Child(@FieldType(Input, "ports")) = .{
            .inputs = inputs,
            .outputs = outputs,
            .binding_ends = @ptrCast(binding_ends),
            .task_ends = @ptrCast(task_ends),
        };

        const task_requests: std.meta.Child(@FieldType(Input, "tasks")) = .{
            .ids = @ptrCast(tasks.items(.id)),
            .values = @ptrCast(tasks.items(.value)),
        };

        const target: std.meta.Child(@FieldType(Input, "target")) = .{
            .bindings = @ptrCast(&binding_types),
            .tasks = @ptrCast(&task_types),
            .inputs = @ptrCast(&inputs),
            .outputs = @ptrCast(&outputs),
        };

        var cursor: std.meta.Child(@FieldType(Input, "cursor")) = .{ .module = 0, .binding = 0, .task = 0, .output = false };
        var empty = std.heap.FixedBufferAllocator.init(&.{});

        while (true) {
            const input: Input = .{ .nodes = &nodes, .ports = &ranges, .tasks = &task_requests, .target = &target, .cursor = &cursor };
            const progress = zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable;
            const unresolved = progress.unresolved orelse break;
            _ = try graph.resolve(@fromBackingInt(unresolved));
            cursor = zx.columns.view(@TypeOf(cursor), progress.cursor);
        }
    } else {
        var binding_start: usize = 0;
        var task_start: usize = 0;

        for (inputs, outputs, binding_ends, task_ends) |*input, *output, binding_end, task_end| {
            for (binding_types[binding_start..binding_end]) |*binding| binding.* = @backingInt(try graph.resolve(@fromBackingInt(binding.*)));
            for (tasks.items(.id)[task_start..task_end], tasks.items(.value)[task_start..task_end]) |id, value| task_types[task_start + id] = @backingInt(try graph.resolve(value));

            input.* = @backingInt(try graph.resolve(@fromBackingInt(input.*)));
            output.* = @backingInt(try graph.resolve(@fromBackingInt(output.*)));
            binding_start = binding_end;
            task_start = task_end;
        }
    }

    var binding_start: usize = 0;
    var task_start: usize = 0;

    for (signatures, inputs, outputs, binding_ends, task_ends) |*signature, input, output, binding_end, task_end| {
        signature.* = .{
            .input_type = @fromBackingInt(input),
            .output_type = @fromBackingInt(output),
            .bindings = .{
                .names = names[binding_start..binding_end],
                .types = @ptrCast(binding_types[binding_start..binding_end]),
            },
            .tasks = @ptrCast(task_types[task_start..task_end]),
        };

        binding_start = binding_end;
        task_start = task_end;
    }

    return signatures;
}
