const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn bind(self: *Lower, body: *std.ArrayList(node.Statement), expression: node.ExpressionId) Lower.Error!node.ExpressionId {
    const name = try self.fresh("operand");

    try body.append(self.allocator, .{ .constant = .{ .name = name, .value = expression } });

    return self.builder.identifier(name);
}

pub fn finish(self: *Lower, body: *std.ArrayList(node.Statement), result: node.ExpressionId) Lower.Error!node.ExpressionId {
    const label = try self.fresh("block");

    try body.append(self.allocator, .{ .break_value = .{ .label = label, .value = result } });

    return self.builder.expression(.{ .block = .{ .label = label, .statements = try self.builder.statements(body.items) } });
}
