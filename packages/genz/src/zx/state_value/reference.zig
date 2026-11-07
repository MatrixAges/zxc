const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn store(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("reference_seed.zig").store(self, body, id, value);

    return @import("../construction/reference.zig").lower(self, body, id, value, false);
}

pub fn copy(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("reference_seed.zig").copy(self, body, id, value);

    return @import("../construction/reference.zig").lower(self, body, id, value, true);
}
