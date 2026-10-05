const std = @import("std");
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

pub fn index(self: *Lower, values: *const node.Expression, position: *const node.Expression) Lower.Error!*const node.Expression {
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, values);
    const offset = try aggregate.bind(self, &body, position);

    try failIf(self, &body, try binary(self, .greater_equal, offset, try self.field(source, "len")), "IndexOutOfBounds");

    return aggregate.finish(self, &body, try self.builder.expression(.{ .index = .{ .target = source, .index = try self.builtin(.intCast, &.{offset}) } }));
}

pub fn failIf(self: *Lower, body: *std.ArrayList(node.Statement), condition: *const node.Expression, name: []const u8) Lower.Error!void {
    const value = try self.builder.expression(.{ .error_value = name });

    const failure = if (self.capture) |boundary|
        try self.allocator.dupe(node.Statement, &.{ .{ .constant = .{ .name = boundary.name, .value = value } }, .{ .break_value = .{ .label = boundary.label, .value = boundary.failure } } })

    else
        try self.allocator.dupe(node.Statement, &.{.{ .result = value }});
    try body.append(self.allocator, .{ .branch = .{ .condition = condition, .yes = failure, .no = &.{} } });
}

pub fn binary(self: *Lower, operator: node.BinaryOperator, left: *const node.Expression, right: *const node.Expression) Lower.Error!*const node.Expression {
    return self.builder.expression(.{ .binary = .{ .operator = operator, .left = left, .right = right } });
}

pub fn standard(self: *Lower, path: []const []const u8, arguments: []const *const node.Expression, fallible: bool) Lower.Error!*const node.Expression {
    return self.call(try standardField(self, path), arguments, fallible);
}

pub fn standardField(self: *Lower, path: []const []const u8) Lower.Error!*const node.Expression {
    var expression = try self.builder.identifier("std");

    for (path) |part| expression = try self.field(expression, part);

    return expression;
}
