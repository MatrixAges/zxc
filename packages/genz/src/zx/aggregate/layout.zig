const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../lower.zig");
const Projection = @import("../iteration/fields/root.zig");

pub const Plan = struct {
    projection: ?*const Projection = null,
    convert_fields: bool = false,
    construct: bool,
};

pub fn plan(self: *const Lower, id: ir.ExprId, type_id: ir.TypeId, layout_only: bool, updated: bool) Plan {
    const selected = self.state_plan.selected[@backingInt(type_id)];

    if (!@import("genz_options").generated_analysis) return seed(self, id, layout_only, updated, selected);

    const entry = @import("generated_object_layout_plan");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .expression = @backingInt(id),
        .loop_states = if (self.loop_fields) |context| context.states else null,
        .state_active = self.state_active,
        .selected = selected,
        .layout_only = layout_only,
        .updated = updated,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const output = zx.columns.invoke(entry.executeValue, fixed.allocator(), &input) catch unreachable;

    return .{
        .projection = if (output.project) self.loop_fields else null,
        .convert_fields = output.convert_fields,
        .construct = output.construct,
    };
}

fn seed(self: *const Lower, id: ir.ExprId, layout_only: bool, updated: bool, selected: bool) Plan {
    if (updated) return .{ .construct = !layout_only and !selected };

    const context = if (self.loop_fields) |value| (if (value.expression(id)) value else null) else null;

    return .{
        .projection = context,
        .convert_fields = self.state_active and !selected,
        .construct = !layout_only and context == null,
    };
}
