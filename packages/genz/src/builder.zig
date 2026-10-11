const std = @import("std");
const node = @import("node.zig");
const Self = @This();

allocator: std.mem.Allocator,
nodes: *@import("node/storage.zig"),
pub fn init(allocator: std.mem.Allocator) std.mem.Allocator.Error!Self {
    const nodes = try allocator.create(@import("node/storage.zig"));
    nodes.* = .init(allocator);

    return .{ .allocator = allocator, .nodes = nodes };
}

pub fn expression(self: Self, value: node.Expression) std.mem.Allocator.Error!node.ExpressionId {
    return self.nodes.append(self.allocator, value);
}

pub fn identifier(self: Self, name: []const u8) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .identifier = name });
}

pub fn integer(self: Self, value: u64) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .integer = value });
}

pub fn string(self: Self, value: []const u8) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .string = value });
}

pub fn field(self: Self, target: node.ExpressionId, name: []const u8) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .field = .{ .target = target, .name = name } });
}

pub fn call(self: Self, callee: node.ExpressionId, arguments: []const node.ExpressionId) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .call = .{ .callee = callee, .arguments = try self.allocator.dupe(node.ExpressionId, arguments) } });
}

pub fn builtin(self: Self, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const node.ExpressionId) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .builtin = .{ .name = name, .arguments = try self.allocator.dupe(node.ExpressionId, arguments) } });
}

pub fn path(self: Self, names: []const []const u8) std.mem.Allocator.Error!node.ExpressionId {
    var result = try self.identifier(names[0]);

    for (names[1..]) |name| result = try self.field(result, name);

    return result;
}

pub fn statements(self: Self, values: []const node.Statement) std.mem.Allocator.Error!node.Block {
    return self.nodes.block(self.allocator, values);
}

pub fn binary(self: Self, operator: node.BinaryOperator, left: node.ExpressionId, right: node.ExpressionId) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .binary = .{ .operator = operator, .left = left, .right = right } });
}

pub fn object(self: Self, fields: []const node.Field) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .object = .{ .fields = fields } });
}

pub fn tuple(self: Self, values: []const node.ExpressionId) std.mem.Allocator.Error!node.ExpressionId {
    return self.expression(.{ .tuple = try self.allocator.dupe(node.ExpressionId, values) });
}

pub fn branch(self: Self, condition: node.ExpressionId, yes: []const node.Statement, no: []const node.Statement) std.mem.Allocator.Error!node.Statement {
    return .{ .branch = .{ .condition = condition, .yes = try self.statements(yes), .no = try self.statements(no) } };
}
