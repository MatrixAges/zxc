const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Fields = @import("fields/root.zig");
const generated = @import("genz_options").generated_analysis;
const entry = if (generated) @import("generated_iteration_step") else struct {};

pub const Input = if (generated) std.meta.Child(entry.Input) else struct {
    body: u32,
    forwarded: ?u32,
    postcondition: bool,
    projected: bool,
    selected_state: bool,
    layout: bool,
    buffered: bool,
};

const Plan = if (generated) std.meta.Child(entry.Output) else struct {
    step: u32,
    by_value: bool,
    first_test: bool,
    after_step: bool,
    classify_renewals: bool,
    inline_lists: bool,
    assignment: enum { Direct, State, Projected },
};

pub fn plan(input: Input) Plan {
    if (comptime !generated) return seed(input);

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const result = zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch unreachable;

    return .{
        .step = result.step,
        .by_value = result.by_value,
        .first_test = result.first_test,
        .after_step = result.after_step,
        .classify_renewals = result.classify_renewals,
        .inline_lists = result.inline_lists,
        .assignment = result.assignment,
    };
}

const Values = struct { condition: node.ExpressionId, value: node.ExpressionId };

pub fn lower(self: *Lower, schedule: Plan, condition: ir.ExprId) Lower.Error!Values {
    const test_value = try self.expr(condition);
    const body: ir.ExprId = @fromBackingInt(schedule.step);
    const value = if (schedule.by_value) try @import("../value_call/root.zig").expression(self, body) else try self.expr(body);

    return .{ .condition = test_value, .value = value };
}

pub const Write = struct {
    type_id: ir.TypeId,
    origin: ir.ExprId,
    target: node.ExpressionId,
    value: node.ExpressionId,
    fields: ?*const Fields = null,
};

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), schedule: Plan, write: Write) Lower.Error!void {
    const basic = @import("../statements/basic.zig");

    switch (schedule.assignment) {
        .Direct => try basic.assignment(self, body, write.target, write.value),
        .Projected => {
            const qualified = try write.fields.?.qualify(self, body, write.origin, write.value);

            try basic.assignment(self, body, write.target, qualified);
        },
        .State => {
            const qualified = try @import("../state_value/ownership.zig").clip(self, body, write.origin, write.value);

            try @import("assignment.zig").append(self, body, write.type_id, write.target, qualified);
        },
    }
}

fn seed(input: Input) Plan {
    return .{
        .step = if (input.projected) input.body else input.forwarded orelse input.body,
        .by_value = input.projected or input.forwarded != null or input.layout,
        .first_test = input.projected and !input.postcondition,
        .after_step = input.projected or input.postcondition,
        .classify_renewals = !input.projected and input.selected_state and input.forwarded == null,
        .inline_lists = !input.projected and input.buffered,
        .assignment = if (input.projected) .Projected else if (input.selected_state) .State else .Direct,
    };
}
