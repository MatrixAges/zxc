const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub const Change = struct { previous: ir.SymbolId, reference: ir.ExprId, field: ir.ObjectField, type_id: ir.TypeId, object: ?ir.ExprId = null, multiple: bool = false };

pub fn lower(lowering: *Lower, id: ir.ExprId, body: *std.ArrayList(node.Statement)) Lower.Error!?node.ExpressionId {
    if (!@import("genz_options").generated_analysis) {
        const change = match(lowering, id) orelse return null;

        return try @import("object_update/seed.zig").lower(lowering, change);
    }

    const change = @import("object_update/matching.zig").match(lowering, id, true) orelse return null;

    return try @import("object_update/emit.zig").expression(lowering, change, body);
}

pub fn match(lowering: *const Lower, id: ir.ExprId) ?Change {
    if (!@import("genz_options").generated_analysis) return @import("object_update/seed.zig").match(lowering, id);

    return @import("object_update/matching.zig").match(lowering, id, false);
}
