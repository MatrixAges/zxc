const std = @import("std");
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");
const common = @import("../common.zig");

pub fn lower(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    const reference = try builder.identifier("reference");
    const nil = try builder.expression(.null_value);
    const api_value = try builder.path(&.{ "api", "Value" });
    var body: std.ArrayList(node.Statement) = .empty;

    try body.appendSlice(builder.allocator, &.{
        try builder.branch(try builder.path(&.{ "self", "context", "closing" }), &.{.{ .result = null }}, &.{}),
        .{ .constant = .{ .name = "result", .value = try builder.expression(.{ .conditional = .{
            .condition = try builder.path(&.{ "self", "output" }),
            .capture = "output",
            .error_capture = "err",
            .yes = try builder.call(try builder.path(&.{ "napi", "write" }), &.{ env, try builder.identifier("output") }),
            .no = try builder.identifier("err"),
        } }) } },
        .{ .variable = .{ .name = "value", .type_expr = api_value, .value = nil } },
        .{ .variable = .{ .name = "reference", .value = try builder.path(&.{ "self", "resolve" }) } },
        .{ .branch = .{
            .condition = try builder.identifier("result"),
            .capture = "output",
            .error_capture = "err",
            .yes = try builder.statements(&.{.{ .assignment = .{ .target = value, .value = try builder.identifier("output") } }}),
            .no = try builder.statements(&.{
                .{ .assignment = .{ .target = reference, .value = try builder.path(&.{ "self", "reject" }) } },
                .{ .variable = .{ .name = "pending", .value = try builder.expression(.{ .boolean = false }) } },
                try common.check(builder, "napi_is_exception_pending", &.{ env, try builder.expression(.{ .address_of = try builder.identifier("pending") }) }),
                try builder.branch(try builder.identifier("pending"), &.{
                    try common.check(builder, "napi_get_and_clear_last_exception", &.{ env, try builder.expression(.{ .address_of = value }) }),
                }, &.{
                    .{ .variable = .{ .name = "message", .type_expr = api_value, .value = nil } },
                    .{ .constant = .{ .name = "name", .value = try builder.builtin(.errorName, &.{try builder.identifier("err")}) } },
                    try common.check(builder, "napi_create_string_utf8", &.{ env, try builder.path(&.{ "name", "ptr" }), try builder.path(&.{ "name", "len" }), try builder.expression(.{ .address_of = try builder.identifier("message") }) }),
                    try common.check(builder, "napi_create_error", &.{ env, nil, try builder.identifier("message"), try builder.expression(.{ .address_of = value }) }),
                }),
            }),
        } },
    });

    for ([_][]const u8{ "callback", "receiver", "ignored" }) |name| {
        try body.append(builder.allocator, .{ .variable = .{ .name = name, .type_expr = api_value, .value = nil } });
    }

    try body.appendSlice(builder.allocator, &.{
        try common.check(builder, "napi_get_reference_value", &.{ env, reference, try builder.expression(.{ .address_of = try builder.identifier("callback") }) }),
        try common.check(builder, "napi_get_undefined", &.{ env, try builder.expression(.{ .address_of = try builder.identifier("receiver") }) }),
        try common.check(builder, "napi_call_function", &.{ env, try builder.identifier("receiver"), try builder.identifier("callback"), try builder.integer(1), try builder.expression(.{ .address_of = try builder.tuple(&.{value}) }), try builder.expression(.{ .address_of = try builder.identifier("ignored") }) }),
    });

    return .{ .function = .{
        .name = "settle",
        .parameters = try builder.allocator.dupe(node.Field, &.{
            .{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.identifier("Self") }) },
            .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) },
        }),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .void }) } }),
        .body = try body.toOwnedSlice(builder.allocator),
    } };
}
