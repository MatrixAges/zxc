const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn convert(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, input: bool) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("view_seed.zig").convert(self, body, id, value, input);
    if (!try @import("view_plan.zig").required(self, id, input)) return value;

    return @import("conversion_emission.zig").lower(self, body, id, value, if (input) .view_value else .view_layout);
}
