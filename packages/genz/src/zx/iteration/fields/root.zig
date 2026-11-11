const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Self = @This();

states: []const bool,
symbols: []const bool,
borrowed: []const bool,
type_id: ir.TypeId,
layout: node.ExpressionId,
seed: node.ExpressionId,
capacity: ?struct { operation: ir.ExprId, source: u32 } = null,
pub fn minimum(self: *const Self, lowering: *Lower, operation: ir.ExprId) Lower.Error!?node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("projection_seed.zig").minimum(self, lowering, operation);

    return @import("projection.zig").minimum(self, lowering, operation);
}

pub fn expression(self: *const Self, id: ir.ExprId) bool {
    return self.states[@backingInt(id)];
}

pub fn symbol(self: *const Self, id: ir.SymbolId) bool {
    return self.symbols[@backingInt(id)];
}

pub fn field(self: *const Self, lowering: *const Lower, target: ir.ExprId, name: []const u8) bool {
    if (!self.expression(target)) return false;

    const fields = lowering.program.typeOf(self.type_id).object;

    for (0..fields.len) |index| {
        if (std.mem.eql(u8, fields.at(index).name, name)) return self.borrowed[index];
    }

    unreachable;
}

pub fn initial(self: *const Self, lowering: *Lower) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("projection_seed.zig").initial(self, lowering);

    return @import("projection.zig").initial(self, lowering);
}

pub fn restore(self: *const Self, lowering: *Lower, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("projection_seed.zig").restore(self, lowering, state);

    return @import("projection.zig").restore(self, lowering, state);
}

pub const maskBorrowed = if (@import("genz_options").generated_analysis)
    @import("ownership.zig").maskBorrowed

else
    @import("projection_seed.zig").maskBorrowed;

pub const qualify = if (@import("genz_options").generated_analysis)
    @import("ownership.zig").qualify

else
    @import("projection_seed.zig").qualify;
