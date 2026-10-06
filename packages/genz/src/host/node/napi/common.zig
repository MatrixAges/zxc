const std = @import("std");
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");

pub fn check(builder: Builder, name: []const u8, arguments: []const *const node.Expression) std.mem.Allocator.Error!node.Statement {
    return .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.identifier("check"), &.{try builder.call(try builder.path(&.{ "api", name }), arguments)}) }) };
}

pub fn address(builder: Builder, name: []const u8) std.mem.Allocator.Error!*const node.Expression {
    return builder.expression(.{ .address_of = try builder.identifier(name) });
}

pub fn failure(builder: Builder, condition: *const node.Expression, name: []const u8) std.mem.Allocator.Error!node.Statement {
    return builder.branch(condition, &.{.{ .result = try builder.expression(.{ .error_value = name }) }}, &.{});
}

pub fn invocation(builder: Builder, name: []const u8, arguments: []const *const node.Expression) std.mem.Allocator.Error!*const node.Expression {
    return builder.expression(.{ .try_value = try builder.call(try builder.identifier(name), arguments) });
}

pub fn parameters(builder: Builder, allocator: bool) std.mem.Allocator.Error![]const node.Field {
    var fields: std.ArrayList(node.Field) = .empty;

    if (allocator) try fields.append(builder.allocator, .{ .name = "allocator", .value = try builder.path(&.{ "std", "mem", "Allocator" }) });

    try fields.appendSlice(builder.allocator, &.{
        .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) },
        .{ .name = "value", .value = try builder.path(&.{ "api", "Value" }) },
    });

    return fields.toOwnedSlice(builder.allocator);
}

pub fn function(builder: Builder, name: []const u8, params: []const node.Field, result: *const node.Expression, body: []const node.Statement) std.mem.Allocator.Error!node.Declaration {
    return .{ .function = .{ .name = name, .parameters = params, .return_type = try builder.expression(.{ .error_union = .{ .payload = result } }), .body = try builder.statements(body) } };
}
