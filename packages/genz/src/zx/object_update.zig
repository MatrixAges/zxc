const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub const Change = struct { previous: ir.SymbolId, reference: ir.ExprId, field: ir.ObjectField, type_id: ir.TypeId };

pub fn lower(lowering: *Lower, id: ir.ExprId) Lower.Error!?node.ExpressionId {
    const change = match(lowering, id) orelse return null;

    if (!@import("genz_options").generated_analysis) return try @import("object_update/seed.zig").lower(lowering, change);

    return try @import("object_update/emit.zig").expression(lowering, change);
}

pub fn match(lowering: *const Lower, id: ir.ExprId) ?Change {
    if (!@import("genz_options").generated_analysis) return @import("object_update/seed.zig").match(lowering, id);

    return @import("object_update/matching.zig").match(lowering, id);
}
