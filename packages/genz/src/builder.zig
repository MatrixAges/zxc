const std = @import("std");
const node = @import("node.zig");
const Self = @This();

allocator: std.mem.Allocator,
pub fn expression(self: Self, value: node.Expression) std.mem.Allocator.Error!*const node.Expression {
    const result = try self.allocator.create(node.Expression);

    result.* = value;

    return result;
}

pub fn identifier(self: Self, name: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .identifier = name });
}

pub fn integer(self: Self, value: u64) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .integer = value });
}

pub fn string(self: Self, value: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .string = value });
}

pub fn field(self: Self, target: *const node.Expression, name: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .field = .{ .target = target, .name = name } });
}

pub fn call(self: Self, callee: *const node.Expression, arguments: []const *const node.Expression) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .call = .{ .callee = callee, .arguments = try self.allocator.dupe(*const node.Expression, arguments) } });
}

pub fn builtin(self: Self, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const *const node.Expression) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .builtin = .{ .name = name, .arguments = try self.allocator.dupe(*const node.Expression, arguments) } });
}

pub fn path(self: Self, names: []const []const u8) std.mem.Allocator.Error!*const node.Expression {
    var result = try self.identifier(names[0]);

    for (names[1..]) |name| result = try self.field(result, name);

    return result;
}

pub fn statements(self: Self, values: []const node.Statement) std.mem.Allocator.Error![]const node.Statement {
    return self.allocator.dupe(node.Statement, values);
}

pub fn binary(self: Self, operator: node.BinaryOperator, left: *const node.Expression, right: *const node.Expression) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .binary = .{ .operator = operator, .left = left, .right = right } });
}

pub fn object(self: Self, fields: []const node.Field) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .object = .{ .fields = try self.allocator.dupe(node.Field, fields) } });
}

pub fn tuple(self: Self, values: []const *const node.Expression) std.mem.Allocator.Error!*const node.Expression {
    return self.expression(.{ .tuple = try self.allocator.dupe(*const node.Expression, values) });
}

pub fn branch(self: Self, condition: *const node.Expression, yes: []const node.Statement, no: []const node.Statement) std.mem.Allocator.Error!node.Statement {
    return .{ .branch = .{ .condition = condition, .yes = try self.statements(yes), .no = try self.statements(no) } };
}
