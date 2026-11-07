const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Lower = @import("../../lower.zig");

pub fn eligible(self: *const Lower, id: ir.ExprId, slot: u32) bool {
    const module = @import("generated_ownership_eligible");
    const Input = std.meta.Child(module.Input);

    const input: Input = .{
        .first = self.plan.slot_first,
        .transfers = self.plan.transfers,
        .node = @backingInt(id),
        .slot = slot,
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(module.executeValue, empty.allocator(), &input) catch unreachable;
}

pub fn needed(self: *const Lower, id: ir.ExprId, type_id: ir.TypeId, slot: u32) bool {
    const module = @import("generated_ownership_needed");
    const Input = std.meta.Child(module.Input);
    const Facts = std.meta.Child(@FieldType(Input, "facts"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), self.program.types);

    const facts: Facts = .{
        .types = &types,
        .selected = self.state_plan.selected,
        .counts = self.slot_counts,
        .first = self.plan.slot_first,
        .transfers = self.plan.transfers,
    };

    const input: Input = .{
        .facts = &facts,
        .node = @backingInt(id),
        .type_id = @backingInt(type_id),
        .slot = slot,
    };

    var empty = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(module.executeValue, empty.allocator(), &input) catch unreachable;
}
