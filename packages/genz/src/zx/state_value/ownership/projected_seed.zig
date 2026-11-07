const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const ownership = @import("../ownership.zig");

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!node.ExpressionId {
    if (!ownership.needed(self, id, type_id, slot)) return value;

    const name = try self.fresh("qualified");
    const source = try self.builder.identifier(name);

    try body.append(self.allocator, .{ .variable = .{
        .name = name,
        .type_expr = try @import("../../types.zig").get(self, self.state_types, type_id),
        .value = value,
    } });

    if (!try @import("outlined_seed.zig").append(self, body, id, type_id, source, slot)) try ownership.clear(self, body, id, type_id, source, slot);

    return source;
}
