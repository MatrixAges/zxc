const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub const Mode = enum { value, value_layout, row_value, pointer, layout, row_layout, borrow, view_value, view_layout };

pub fn convert(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.TypeId, value: node.ExpressionId, mode: Mode) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("conversion_seed.zig").convert(self, body, id, value, mode);
    if (!self.state_plan.represented(self.program, id)) return value;

    return switch (mode) {
        .view_value, .view_layout => @import("view.zig").convert(self, body, id, value, mode == .view_value),
        .borrow => @import("borrow.zig").lower(self, body, body, id, value),
        else => @import("conversion_emission.zig").lower(self, body, id, value, mode),
    };
}
