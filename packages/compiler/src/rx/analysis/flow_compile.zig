const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const zx = @import("zx");
const Module = @import("module.zig");
const Prepared = @import("project/flow.zig");
const Flow = @import("program/flow.zig");
const expression = @import("expression.zig");
const target = @import("call/target.zig");
const Self = @This();
pub const TaskType = struct { id: usize, output_type: zx.ir.TypeId };
pub const Error = std.mem.Allocator.Error || error{InvalidFlow};

allocator: std.mem.Allocator,
owner: []const u8,
types: []const zx.ir.Type,
output_type: zx.ir.TypeId,
loaded: []const Module.Loaded,
results: []const Module.Binding,
tasks: []const TaskType = &.{},
bindings: std.ArrayList(frontend.expressions.Binding) = .empty,
calls: std.ArrayList(Module.Call) = .empty,
next_binding: usize = 0,
unit_input: bool = false,
issue: ?expression.Diagnostic = null,
pub fn steps(self: *Self, sequence: []const Prepared.Step) Error![]const Flow.Step {
    var result: std.ArrayList(Flow.Step) = .empty;

    for (sequence) |step| {
        const compiled: Flow.Step = switch (step.value) {
            .call => |index| .{ .call = try self.call(self.loaded[index]) },
            .parallel => |branches| parallel: {
                const count = self.bindings.items.len;
                const calls = try self.allocator.alloc(usize, branches.len);
                var outputs: std.ArrayList(frontend.expressions.Binding) = .empty;

                for (branches, calls) |branch, *compiled_call| {
                    compiled_call.* = switch (branch) {
                        .call => |index| try self.call(self.loaded[index]),
                        .task => |task| try @import("parallel_task.zig").compile(self, task),
                    };

                    const invocation = self.calls.items[compiled_call.*];

                    if (!try frontend.isParallelSafe(self.allocator, invocation.callee)) {
                        const location = switch (branch) {
                            .call => |index| self.loaded[index].node.location,
                            .task => |task| task.node.location,
                        };

                        self.issue = .{ .location = location, .issue = .{ .code = .unsupported, .span = .{ .start = location.offset, .end = location.offset }, .message = "Parallel branches require pure functions without Store capabilities or native external calls" } };

                        return error.InvalidFlow;
                    }

                    try outputs.appendSlice(self.allocator, self.bindings.items[count..]);

                    self.bindings.shrinkRetainingCapacity(count);
                }

                try self.bindings.appendSlice(self.allocator, outputs.items);

                break :parallel .{ .parallel = calls };
            },
            .result => |attribute| .{ .result = try self.value(attribute, self.output_type) },
            .task => |task| scope: {
                const count = self.bindings.items.len;
                const nested = try self.steps(task.body);
                var compiled: @FieldType(Flow.Step, "task") = .{ .body = nested };
                var published: ?Module.Binding = null;

                if (target.optionalAttribute(task.node, "out")) |attribute| {
                    const binding = self.results[self.next_binding];
                    self.next_binding += 1;
                    const has_value = binding.type_id != @as(zx.ir.TypeId, @fromBackingInt(@intCast(@backingInt(zx.ir.Scalar.void))));
                    compiled.output = .{ .value = try self.value(attribute, binding.type_id), .name = if (has_value) binding.name else null };

                    if (has_value) published = binding;
                }

                self.bindings.shrinkRetainingCapacity(count);

                if (published) |binding| try self.bindings.append(self.allocator, .{ .name = binding.name, .type_id = binding.type_id });

                break :scope .{ .task = compiled };
            },
            .selection => |selection| selection: {
                const subject = try self.value(selection.subject, null);
                const cases = try self.allocator.alloc(Flow.Case, selection.cases.len);
                const count = self.bindings.items.len;

                for (selection.cases, cases) |case, *item| {
                    const label = if (case.value) |attribute| try self.value(attribute, subject.output_type) else null;
                    const body = try self.steps(case.body);

                    self.bindings.shrinkRetainingCapacity(count);

                    item.* = .{ .value = label, .body = body };
                }

                if (@import("selection.zig").check(subject, selection.subject, cases, selection.cases)) |issue| {
                    self.issue = issue;

                    return error.InvalidFlow;
                }

                break :selection .{ .selection = .{ .subject = subject, .cases = cases } };
            },
        };

        try result.append(self.allocator, compiled);
    }

    return result.items;
}

fn value(self: *Self, attribute: rx.ast.Attribute, expected: ?zx.ir.TypeId) Error!zx.ir.Program {
    const compiled = try expression.compileForLinking(self.allocator, self.owner, attribute, .{ .types = self.types, .bindings = self.bindings.items, .unit_bindings = if (self.unit_input) &.{"$in"} else &.{}, .expected = expected });

    if (compiled.value == .diagnostic) {
        self.issue = compiled.value.diagnostic;

        return error.InvalidFlow;
    }

    self.types = compiled.value.ir.types;

    return compiled.value.ir;
}

fn call(self: *Self, loaded: Module.Loaded) Error!usize {
    const count = self.bindings.items.len;

    for (loaded.getters) |getter| try self.bindings.append(self.allocator, .{ .name = getter.name, .type_id = getter.slot.type_id });

    const argument = if (target.optionalAttribute(loaded.node, "in")) |attribute| try self.value(attribute, loaded.function.program.input_type) else try @import("call/unit.zig").create(self.allocator, self.owner, self.types, loaded.node.location);

    self.bindings.shrinkRetainingCapacity(count);

    var out: ?[]const u8 = null;
    const binding = self.results[self.next_binding];

    self.next_binding += 1;

    if (binding.type_id != @as(zx.ir.TypeId, @fromBackingInt(@intCast(@backingInt(zx.ir.Scalar.void))))) {
        try self.bindings.append(self.allocator, .{ .name = binding.name, .type_id = binding.type_id });

        out = binding.name;
    }

    const index = self.calls.items.len;

    try self.calls.append(self.allocator, .{ .callee = loaded.function.program, .store_initializers = loaded.function.store_initializers, .argument = argument, .input_omitted = target.optionalAttribute(loaded.node, "in") == null, .out = out, .getters = loaded.getters });

    return index;
}
