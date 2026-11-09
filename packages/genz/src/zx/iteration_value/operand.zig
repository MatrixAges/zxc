const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Self = @This();

name: []const u8,
value: node.ExpressionId,
reference: node.ExpressionId,
pub const empty: Self = .{ .name = &.{}, .value = @fromBackingInt(0), .reference = @fromBackingInt(0) };

pub fn lower(lowering: *Lower, id: ir.ExprId) Lower.Error!Self {
    var storage: [1]node.Statement = undefined;
    var body = std.ArrayList(node.Statement).initBuffer(&storage);
    const reference = try @import("../aggregate.zig").bind(lowering, &body, try lowering.expr(id));

    std.debug.assert(body.items.len == 1);

    const binding = body.items[0].constant;

    return .{ .name = binding.name, .value = binding.value, .reference = reference };
}
