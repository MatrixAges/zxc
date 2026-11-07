const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!bool {
    if (!@import("genz_options").generated_analysis) return @import("outlined_seed.zig").append(self, body, id, type_id, value, slot);
    if (!@import("query.zig").outlined(self, id, type_id, slot)) return false;

    const type_expr = try @import("../../types.zig").get(self, self.state_types, type_id);
    const name = try @import("naming.zig").build(self, id, type_id, slot);

    try @import("helper.zig").append(self, body, id, type_id, slot, type_expr, name, value);

    return true;
}
