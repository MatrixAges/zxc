const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn renewValue(self: *Lower, id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    var body: std.ArrayList(node.Statement) = .empty;
    const name = try self.fresh("renewed");
    const renewed = try self.builder.identifier(name);
    const source = if (self.state_active) try @import("../state_value/ownership.zig").clip(self, &body, id, value) else value;

    try body.append(self.allocator, .{ .variable = .{ .name = name, .value = source } });
    for (self.plan.renewals) |renewal| if (renewal.owner == @backingInt(id) and renewal.value) try @import("../growth.zig").renew(self, &body, self.program.expression(id).type_id, renewed, renewal.path);

    return aggregate.finish(self, &body, renewed);
}
