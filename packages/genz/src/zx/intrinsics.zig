const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn index(self: *Lower, values: node.ExpressionId, position: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("intrinsics/seed.zig").index(self, values, position);

    return @import("intrinsics/index.zig").lower(self, values, position);
}

pub fn failIf(self: *Lower, body: *std.ArrayList(node.Statement), condition: node.ExpressionId, name: []const u8) Lower.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("intrinsics/seed.zig").failIf(self, body, condition, name);

    return @import("intrinsics/guard.zig").lower(self, body, condition, name);
}

pub fn binary(self: *Lower, operator: node.BinaryOperator, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
    return self.builder.expression(.{ .binary = .{ .operator = operator, .left = left, .right = right } });
}

pub fn standard(self: *Lower, path: []const []const u8, arguments: []const node.ExpressionId, fallible: bool) Lower.Error!node.ExpressionId {
    return self.call(try standardField(self, path), arguments, fallible);
}

pub fn standardField(self: *Lower, path: []const []const u8) Lower.Error!node.ExpressionId {
    var expression = try self.builder.identifier("std");

    for (path) |part| expression = try self.field(expression, part);

    return expression;
}
