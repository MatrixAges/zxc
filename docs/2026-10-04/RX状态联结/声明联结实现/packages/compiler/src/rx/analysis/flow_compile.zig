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
pub const Error = std.mem.Allocator.Error || error{InvalidFlow};

allocator: std.mem.Allocator,
owner: []const u8,
types: []const zx.ir.Type,
output_type: zx.ir.TypeId,
loaded: []const Module.Loaded,
results: []const Module.Binding,
bindings: std.ArrayList(frontend.expressions.Binding) = .empty,
calls: std.ArrayList(Module.Call) = .empty,
next_binding: usize = 0,
issue: ?expression.Diagnostic = null,
pub fn steps(self: *Self, sequence: []const Prepared.Step) Error![]const Flow.Step {
    var result: std.ArrayList(Flow.Step) = .empty;

    for (sequence) |step| {
        const compiled: Flow.Step = switch (step.value) {
            .call => |index| .{ .call = try self.call(self.loaded[index]) },
            .result => |attribute| .{ .result = try self.value(attribute, self.output_type) },
            .task => |body| task: {
                const count = self.bindings.items.len;
                const nested = try self.steps(body);

                self.bindings.shrinkRetainingCapacity(count);

                break :task .{ .task = nested };
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
    const compiled = try expression.compileForLinking(self.allocator, self.owner, attribute, .{ .types = self.types, .bindings = self.bindings.items, .expected = expected });

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

    const argument = try self.value(target.attribute(loaded.node, "in"), loaded.function.program.input_type);

    self.bindings.shrinkRetainingCapacity(count);

    var out: ?[]const u8 = null;

    for (loaded.node.attributes) |attribute| {
        if (!std.mem.eql(u8, attribute.name, "out")) continue;

        const binding = self.results[self.next_binding];

        try self.bindings.append(self.allocator, .{ .name = binding.name, .type_id = binding.type_id });

        out = binding.name;
        self.next_binding += 1;
    }

    const index = self.calls.items.len;

    try self.calls.append(self.allocator, .{ .callee = loaded.function.program, .argument = argument, .out = out, .getters = loaded.getters });

    return index;
}
