const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub const Change = struct { previous: ir.SymbolId, reference: ir.ExprId, field: ir.ObjectField, type_id: ir.TypeId, object: ?ir.ExprId = null, multiple: bool = false };

pub fn lower(lowering: *Lower, scratch: std.mem.Allocator, id: ir.ExprId, body: *std.ArrayList(node.Statement)) Lower.Error!?node.ExpressionId {
    if (!@import("genz_options").generated_analysis) {
        const change = @import("object_update/seed.zig").matchEvaluated(lowering, id) orelse return null;

        return try @import("object_update/seed.zig").lower(lowering, change, body);
    }

    const plan = try @import("object_update/matching.zig").match(lowering, scratch, id, true) orelse return null;

    return try @import("object_update/emit.zig").expression(lowering, scratch, plan, body);
}

pub fn match(lowering: *const Lower, id: ir.ExprId) ?Change {
    if (!@import("genz_options").generated_analysis) return @import("object_update/seed.zig").match(lowering, id);

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const result = @import("object_update/matching.zig").match(lowering, fixed.allocator(), id, false) catch unreachable;

    return if (result) |plan| plan.change else null;
}
