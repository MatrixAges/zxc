const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn check(builder: Builder, name: []const u8, arguments: []const *const node.Expression) std.mem.Allocator.Error!node.Statement {
    const call = try builder.call(try builder.path(&.{ "api", name }), arguments);

    return .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "napi", "check" }), &.{call}) }) };
}

pub fn context(builder: Builder) std.mem.Allocator.Error!node.Statement {
    const value = try builder.builtin(.ptrCast, &.{try builder.builtin(.alignCast, &.{try builder.expression(.{ .optional_unwrap = try builder.identifier("data") })})});

    return .{ .constant = .{ .name = "context", .type_expr = try builder.expression(.{ .pointer = try builder.identifier("Context") }), .value = value } };
}

pub fn dataType(builder: Builder) std.mem.Allocator.Error!*const node.Expression {
    return builder.expression(.{ .optional_type = try builder.expression(.{ .pointer = try builder.expression(.{ .primitive = .anyopaque }) }) });
}

pub fn callback(builder: Builder, name: []const u8, target: []const u8, exported: bool) std.mem.Allocator.Error!node.Declaration {
    const env = try builder.identifier("env");
    const invocation = try builder.call(try builder.identifier(target), &.{ env, try builder.identifier("info") });
    const failure = try builder.expression(.{ .catch_scope = .{ .value = invocation, .capture = "err", .body = try builder.statements(&.{.{ .result = try builder.call(try builder.path(&.{ "napi", "fail" }), &.{ env, try builder.identifier("err") }) }}) } });

    return .{ .function = .{
        .name = name,
        .parameters = try parameters(builder),
        .return_type = try builder.path(&.{ "api", "Value" }),
        .body = try builder.statements(&.{.{ .result = failure }}),
        .exported = exported,
        .calling_convention = try builder.expression(.{ .enum_literal = "c" }),
    } };
}

pub fn parameters(builder: Builder) std.mem.Allocator.Error![]const node.Field {
    return builder.allocator.dupe(node.Field, &.{
        .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) },
        .{ .name = "info", .value = try builder.path(&.{ "api", "Info" }) },
    });
}
