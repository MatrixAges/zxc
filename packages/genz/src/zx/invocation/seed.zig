const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn call(self: *Lower, callee: node.ExpressionId, arguments: []const node.ExpressionId, fallible: bool) Lower.Error!node.ExpressionId {
    const target = self.builder.nodes.get(callee);

    if (target == .field) {
        const owner = self.builder.nodes.get(target.field.target);

        if (owner == .identifier and std.mem.eql(u8, owner.identifier, "allocator")) self.uses_allocator = true;
    }

    for (arguments) |argument_id| {
        const argument = self.builder.nodes.get(argument_id);

        if (argument == .identifier and std.mem.eql(u8, argument.identifier, "allocator")) self.uses_allocator = true;
    }

    const result = try self.builder.expression(.{ .call = .{ .callee = callee, .arguments = try self.allocator.dupe(node.ExpressionId, arguments) } });

    if (!fallible) return result;
    if (self.capture) |boundary| return self.builder.expression(.{ .catch_value = .{ .value = result, .capture = boundary.name, .label = boundary.label, .result = boundary.failure } });

    return self.builder.expression(.{ .try_value = result });
}

pub fn builtin(self: *Lower, name: @FieldType(@FieldType(node.Expression, "builtin"), "name"), arguments: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    return self.builder.expression(.{ .builtin = .{ .name = name, .arguments = try self.allocator.dupe(node.ExpressionId, arguments) } });
}
