const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn eligible(self: *const Lower, id: ir.ExprId, slot: u32) bool {
    if (!@import("genz_options").generated_analysis) return @import("ownership/query_seed.zig").eligible(self, id, slot);

    return @import("ownership/query.zig").eligible(self, id, slot);
}

pub fn clip(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    const type_id = self.program.expression(id).type_id;

    return projected(self, body, id, type_id, value, 0);
}

pub fn needsClip(self: *const Lower, id: ir.ExprId) bool {
    return needed(self, id, self.program.expression(id).type_id, 0);
}

pub fn carries(self: *const Lower, type_id: ir.TypeId) bool {
    return needed(self, @fromBackingInt(std.math.maxInt(u32)), type_id, 0);
}

pub fn erase(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    return projected(self, body, @fromBackingInt(std.math.maxInt(u32)), type_id, value, 0);
}

pub fn projected(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!node.ExpressionId {
    if (!needed(self, id, type_id, slot)) return value;

    const name = try self.fresh("qualified");
    const source = try self.builder.identifier(name);

    try body.append(self.allocator, .{ .variable = .{
        .name = name,
        .type_expr = try @import("../types.zig").get(self, self.state_types, type_id),
        .value = value,
    } });

    if (!try @import("ownership/outlined.zig").append(self, body, id, type_id, source, slot)) try clear(self, body, id, type_id, source, slot);

    return source;
}

pub fn count(self: *const Lower, id: ir.TypeId) u32 {
    return if (@backingInt(id) < self.slot_counts.len) self.slot_counts[@backingInt(id)] else 0;
}

pub fn needed(self: *const Lower, id: ir.ExprId, type_id: ir.TypeId, slot: u32) bool {
    if (!@import("genz_options").generated_analysis) return @import("ownership/query_seed.zig").needed(self, id, type_id, slot);

    return @import("ownership/query.zig").needed(self, id, type_id, slot);
}

pub fn clear(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("ownership/clear_seed.zig").clear(self, body, id, type_id, value, slot);

    return @import("ownership/emission.zig").clear(self, body, id, type_id, value, slot);
}
