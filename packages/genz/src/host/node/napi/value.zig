const std = @import("std");
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");
const common = @import("common.zig");

pub fn declarations(builder: Builder) std.mem.Allocator.Error![]const node.Declaration {
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    const result = try builder.identifier("result");
    const nil = try builder.expression(.null_value);
    const no = try builder.expression(.{ .boolean = false });
    const status = try builder.identifier("status");
    const zero = try builder.integer(0);
    const void_type = try builder.expression(.{ .primitive = .void });
    const size = try builder.identifier("size");
    const bytes = try builder.identifier("bytes");

    return builder.allocator.dupe(node.Declaration, &.{
        .{ .function = .{
            .name = "check",
            .exported = true,
            .parameters = try builder.allocator.dupe(node.Field, &.{.{ .name = "status", .value = try builder.path(&.{ "api", "Status" }) }}),
            .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = void_type } }),
            .body = try builder.statements(&.{
                try common.failure(builder, try builder.binary(.equal, status, try builder.expression(.{ .enum_literal = "pending_exception" })), "PendingException"),
                try common.failure(builder, try builder.binary(.not_equal, status, try builder.expression(.{ .enum_literal = "ok" })), "InvalidNodeValue"),
            }),
        } },
        .{ .function = .{
            .name = "fail",
            .exported = true,
            .parameters = try builder.allocator.dupe(node.Field, &.{
                .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) },
                .{ .name = "err", .value = try builder.expression(.{ .primitive = .anyerror }) },
            }),
            .return_type = try builder.path(&.{ "api", "Value" }),
            .body = try builder.statements(&.{
                .{ .variable = .{ .name = "pending", .value = no } },
                try builder.branch(try builder.binary(.logical_and, try builder.binary(.equal, try builder.call(try builder.path(&.{ "api", "napi_is_exception_pending" }), &.{ env, try common.address(builder, "pending") }), try builder.expression(.{ .enum_literal = "ok" })), try builder.expression(.{ .unary = .{ .operator = .not, .operand = try builder.identifier("pending") } })), &.{
                    .{ .discard = try builder.call(try builder.path(&.{ "api", "napi_throw_error" }), &.{ env, nil, try builder.builtin(.errorName, &.{try builder.identifier("err")}) }) },
                }, &.{}),
                .{ .result = nil },
            }),
        } },
        try common.function(builder, "kind", try common.parameters(builder, false), try builder.path(&.{ "api", "Kind" }), &.{
            .{ .variable = .{ .name = "result", .type_expr = try builder.path(&.{ "api", "Kind" }), .value = try builder.expression(.undefined_value) } },
            try common.check(builder, "napi_typeof", &.{ env, value, try common.address(builder, "result") }),
            .{ .result = result },
        }),
        try common.function(builder, "length", try common.parameters(builder, false), try builder.expression(.{ .primitive = .u32 }), &.{
            .{ .variable = .{ .name = "is_array", .value = no } },
            try common.check(builder, "napi_is_array", &.{ env, value, try common.address(builder, "is_array") }),
            try common.failure(builder, try builder.expression(.{ .unary = .{ .operator = .not, .operand = try builder.identifier("is_array") } }), "ExpectedArray"),
            .{ .variable = .{ .name = "result", .type_expr = try builder.expression(.{ .primitive = .u32 }), .value = zero } },
            try common.check(builder, "napi_get_array_length", &.{ env, value, try common.address(builder, "result") }),
            .{ .result = result },
        }),
        try common.function(builder, "string", try common.parameters(builder, true), try builder.expression(.{ .const_slice = try builder.expression(.{ .primitive = .u8 }) }), &.{
            .{ .variable = .{ .name = "size", .type_expr = try builder.expression(.{ .primitive = .usize }), .value = zero } },
            try common.check(builder, "napi_get_value_string_utf8", &.{ env, value, nil, zero, try common.address(builder, "size") }),
            .{ .constant = .{ .name = "bytes", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "allocator", "alloc" }), &.{
                try builder.expression(.{ .primitive = .u8 }),
                try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "std", "math", "add" }), &.{ try builder.expression(.{ .primitive = .usize }), size, try builder.integer(1) }) }),
            }) }) } },
            try common.check(builder, "napi_get_value_string_utf8", &.{ env, value, try builder.field(bytes, "ptr"), try builder.field(bytes, "len"), try common.address(builder, "size") }),
            .{ .result = try builder.expression(.{ .slice = .{ .target = bytes, .start = zero, .end = size } }) },
        }),
    });
}
