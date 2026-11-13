const std = @import("std");
const zx = @import("zx");
const Module = @import("../module.zig");
const Graph = @import("../inference/types.zig");
const Ports = @import("constraints.zig").Ports;
const Requests = @import("signatures/requests.zig");
const generated = @import("rx_options").generated_graph;
const rule = if (generated) @import("generated_rx_signature_order") else void;
const seed = @import("signatures/seed.zig");
const Stage = if (generated) rule.Output else seed.Stage;

pub const Signature = struct {
    input_type: zx.ir.TypeId,
    output_type: zx.ir.TypeId,
    bindings: []const Module.Binding,
    tasks: []const zx.ir.TypeId,
};

pub fn resolve(allocator: std.mem.Allocator, graph: *Graph, ports: Ports, requests: Requests) zx.Error![]const Signature {
    const signatures = try allocator.alloc(Signature, ports.len);

    errdefer allocator.free(signatures);

    const bindings = try allocator.alloc(Module.Binding, requests.bindings.items.len);

    errdefer allocator.free(bindings);

    const tasks = try allocator.alloc(zx.ir.TypeId, requests.tasks.items.len);

    errdefer allocator.free(tasks);

    const inputs = ports.items(.input);
    const outputs = ports.items(.output);
    const binding_ends = ports.items(.binding_end);
    const task_ends = ports.items(.task_end);
    var first_binding: usize = 0;
    var first_task: usize = 0;

    for (signatures, inputs, outputs, binding_ends, task_ends) |*signature, input, output, binding_end, task_end| {
        const publication: Publication = .{
            .graph = graph,
            .signature = signature,
            .input = input,
            .output = output,
            .binding_requests = requests.bindings.items[first_binding..binding_end],
            .task_requests = requests.tasks.items[first_task..task_end],
            .bindings = bindings[first_binding..binding_end],
            .tasks = tasks[first_task..task_end],
        };

        try publication.run(.Start);

        first_binding = binding_end;
        first_task = task_end;
    }

    return signatures;
}

const Publication = struct {
    graph: *Graph,
    signature: *Signature,
    input: Graph.Id,
    output: Graph.Id,
    binding_requests: []const Requests.Binding,
    task_requests: []const Requests.Task,
    bindings: []Module.Binding,
    tasks: []zx.ir.TypeId,
    inline fn run(self: Publication, comptime stage: Stage) zx.Error!void {
        switch (stage) {
            .Start => {},
            .Bindings => {
                for (self.binding_requests, self.bindings) |request, *binding| {
                    binding.* = .{ .name = request.name, .type_id = try self.graph.resolve(request.value) };
                }

                self.signature.bindings = self.bindings;
            },
            .Tasks => {
                for (self.task_requests) |request| self.tasks[request.id] = try self.graph.resolve(request.value);

                self.signature.tasks = self.tasks;
            },
            .Input => self.signature.input_type = try self.graph.resolve(self.input),
            .Output => self.signature.output_type = try self.graph.resolve(self.output),
            .Done => return,
        }

        return self.run(comptime advance(stage));
    }
};

fn advance(comptime stage: Stage) Stage {
    if (!generated) return seed.advance(stage);

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return rule.executeValue(empty.allocator(), stage) catch unreachable;
}
