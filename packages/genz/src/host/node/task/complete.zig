const std = @import("std");
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");
const common = @import("../common.zig");

pub fn lower(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    const busy = try builder.path(&.{ "context", "busy" });
    const head = try builder.path(&.{ "context", "head" });
    const nil = try builder.expression(.null_value);
    var body: std.ArrayList(node.Statement) = .empty;

    try body.appendSlice(builder.allocator, &.{
        try selfBinding(builder),
        .{ .constant = .{ .name = "context", .value = try builder.path(&.{ "self", "context" }) } },
        .{ .expression = try builder.call(try builder.path(&.{ "context", "retain" }), &.{}) },
        .{ .defer_expression = try builder.call(try builder.path(&.{ "context", "release" }), &.{}) },
        .{ .assignment = .{ .target = busy, .value = try builder.expression(.{ .boolean = true }) } },
        .{ .defer_scope = try builder.statements(&.{.{ .assignment = .{ .target = busy, .value = try builder.expression(.{ .boolean = false }) } }}) },
        try builder.branch(try builder.binary(.not_equal, try builder.identifier("status"), try builder.expression(.{ .enum_literal = "ok" })), &.{.{ .assignment = .{ .target = try builder.path(&.{ "self", "output" }), .value = try builder.expression(.{ .error_value = "AsyncWorkCancelled" }) } }}, &.{}),
        try settle(builder, "self"),
        .{ .expression = try builder.call(try builder.path(&.{ "self", "destroy" }), &.{}) },
    });

    if (stateful) try body.append(builder.allocator, .{ .while_loop = .{
        .condition = head,
        .capture = "next",
        .body = try builder.statements(&.{
            .{ .assignment = .{ .target = head, .value = try builder.path(&.{ "next", "next" }) } },
            try builder.branch(try builder.binary(.equal, head, nil), &.{.{ .assignment = .{ .target = try builder.path(&.{ "context", "tail" }), .value = nil } }}, &.{}),
            .{ .expression = try builder.expression(.{ .catch_scope = .{
                .value = try builder.call(try builder.path(&.{ "next", "start" }), &.{}),
                .capture = "err",
                .body = try builder.statements(&.{
                    .{ .assignment = .{ .target = try builder.path(&.{ "next", "output" }), .value = try builder.identifier("err") } },
                    try settle(builder, "next"),
                    .{ .expression = try builder.call(try builder.path(&.{ "next", "destroy" }), &.{}) },
                    .continue_loop,
                }),
            } }) },
            .{ .result = null },
        }),
    } });

    try body.append(builder.allocator, .{ .assignment = .{ .target = try builder.path(&.{ "context", "running" }), .value = try builder.expression(.{ .boolean = false }) } });

    return .{ .function = .{
        .name = "complete",
        .exported = true,
        .calling_convention = try builder.expression(.{ .enum_literal = "c" }),
        .parameters = try builder.allocator.dupe(node.Field, &.{
            .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) },
            .{ .name = "status", .value = try builder.path(&.{ "api", "Status" }) },
            .{ .name = "data", .value = try common.dataType(builder) },
        }),
        .return_type = try builder.expression(.{ .primitive = .void }),
        .body = try body.toOwnedSlice(builder.allocator),
    } };
}

pub fn selfBinding(builder: Builder) std.mem.Allocator.Error!node.Statement {
    return .{ .constant = .{ .name = "self", .type_expr = try builder.expression(.{ .pointer = try builder.identifier("Self") }), .value = try builder.builtin(.ptrCast, &.{try builder.builtin(.alignCast, &.{try builder.expression(.{ .optional_unwrap = try builder.identifier("data") })})}) } };
}

fn settle(builder: Builder, target: []const u8) std.mem.Allocator.Error!node.Statement {
    return .{ .expression = try builder.expression(.{ .catch_scope = .{
        .value = try builder.call(try builder.identifier("settle"), &.{ try builder.identifier(target), try builder.identifier("env") }),
        .body = try builder.statements(&.{.{ .expression = try builder.call(try builder.path(&.{ "context", "close" }), &.{}) }}),
    } }) };
}
