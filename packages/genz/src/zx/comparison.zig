const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn equal(self: *Lower, type_id: ir.TypeId, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("comparison/seed.zig").equal(self, type_id, left, right);

    return @import("comparison/equality.zig").lower(self, type_id, left, right);
}

pub fn ordering(self: *Lower, type_id: ir.TypeId) Lower.Error!node.Declaration {
    if (!@import("genz_options").generated_analysis) return @import("comparison/seed.zig").ordering(self, type_id);

    return @import("comparison/ordering.zig").lower(self, type_id);
}

pub fn name(self: *Lower, type_id: ir.TypeId) Lower.Error![]const u8 {
    if (!@import("genz_options").generated_analysis) return @import("comparison/seed.zig").name(self, type_id);

    return @import("comparison/name.zig").lower(self, type_id);
}
