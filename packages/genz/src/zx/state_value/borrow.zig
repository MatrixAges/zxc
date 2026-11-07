const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, storage: *std.ArrayList(node.Statement), body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("borrow_seed.zig").lower(self, storage, body, id, value);
    if (!self.state_plan.represented(self.program, id)) return value;

    return @import("conversion_emission.zig").lowerWithStorage(self, storage, body, id, value, .borrow);
}
