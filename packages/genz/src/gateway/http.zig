const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const invoke = @import("invoke.zig");

pub fn readBody(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const alloc = try builder.identifier("allocator");
    const head = try builder.path(&.{ "request", "head" });
    const expect = try builder.field(head, "expect");
    const encoding = try builder.field(head, "transfer_encoding");
    const length = try builder.binary(.coalesce, try builder.field(head, "content_length"), try builder.integer(0));
    const maximum = try builder.identifier("max_body_bytes");
    const body = try builder.identifier("body");
    const err = try builder.identifier("err");
    const reader = try builder.path(&.{ "request", "server", "reader" });
    const bytes = try builder.expression(.{ .const_slice = try builder.expression(.{ .primitive = .u8 }) });
    const expected = try builder.call(try builder.path(&.{ "std", "ascii", "eqlIgnoreCase" }), &.{ try builder.identifier("expect"), try builder.string("100-continue") });
    const read = try builder.call(try builder.path(&.{ "reader", "allocRemaining" }), &.{ alloc, try builder.call(try builder.expression(.{ .enum_literal = "limited" }), &.{try builder.binary(.saturating_add, maximum, try builder.integer(1))}) });

    const read_result = try builder.expression(.{ .catch_scope = .{ .value = read, .capture = "err", .body = try builder.statements(&.{
        try builder.branch(try builder.binary(.equal, err, try builder.expression(.{ .error_value = "OutOfMemory" })), &.{.{ .result = err }}, &.{}),
        try builder.branch(try builder.binary(.equal, err, try builder.expression(.{ .error_value = "StreamTooLong" })), &.{try reply(builder, "payload_too_large", "request body too large")}, &.{try reply(builder, "bad_request", "invalid request body")}),
        .{ .result = try builder.expression(.null_value) },
    }) } });

    return .{ .function = .{
        .name = "readBody",
        .parameters = try builder.allocator.dupe(node.Field, &.{
            .{ .name = "allocator", .value = try builder.path(&.{ "std", "mem", "Allocator" }) },
            .{ .name = "request", .value = try requestType(builder) },
        }),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .optional_type = bytes }) } }),
        .body = try builder.statements(&.{
            .{ .branch = .{ .condition = expect, .capture = "expect", .yes = try builder.statements(&.{
                try reject(builder, try builder.expression(.{ .unary = .{ .operator = .not, .operand = expected } }), "expectation_failed", "unsupported expectation"),
                .{ .assignment = .{ .target = expect, .value = try builder.string("100-continue") } },
            }), .no = &.{} } },
            try reject(builder, try builder.binary(.not_equal, try builder.field(head, "transfer_compression"), try builder.expression(.{ .enum_literal = "identity" })), "unsupported_media_type", "compressed input is unsupported"),
            try reject(builder, try builder.binary(.greater, length, maximum), "payload_too_large", "request body too large"),
            .{ .constant = .{ .name = "flush", .value = try builder.binary(.not_equal, expect, try builder.expression(.null_value)) } },
            .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "request", "writeExpectContinue" }), &.{}) }) },
            try builder.branch(try builder.identifier("flush"), &.{.{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "request", "server", "out", "flush" }), &.{}) }) }}, &.{}),
            .{ .variable = .{ .name = "buffer", .type_expr = try builder.expression(.{ .fixed_array_type = .{ .length = try builder.integer(4096), .element = try builder.expression(.{ .primitive = .u8 }) } }), .value = try builder.expression(.undefined_value) } },
            .{ .constant = .{ .name = "length", .value = try builder.expression(.{ .conditional = .{
                .condition = try builder.binary(.equal, encoding, try builder.expression(.{ .enum_literal = "none" })),
                .yes = length,
                .no = try builder.expression(.null_value),
            } }) } },
            .{ .constant = .{ .name = "reader", .value = try builder.call(try builder.field(reader, "bodyReader"), &.{ try builder.expression(.{ .address_of = try builder.identifier("buffer") }), encoding, try builder.identifier("length") }) } },
            .{ .constant = .{ .name = "body", .value = read_result } },
            try reject(builder, try builder.binary(.greater, try builder.field(body, "len"), maximum), "payload_too_large", "request body too large"),
            try reject(builder, try builder.binary(.not_equal, try builder.field(reader, "state"), try builder.expression(.{ .enum_literal = "ready" })), "bad_request", "truncated request body"),
            .{ .result = body },
        }),
    } };
}

pub fn respond(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const options = try builder.object(&.{
        .{ .name = "status", .value = try builder.identifier("status") },
        .{ .name = "keep_alive", .value = try builder.expression(.{ .boolean = false }) },
        .{ .name = "extra_headers", .value = try builder.identifier("headers") },
    });

    return .{ .function = .{
        .name = "respond",
        .parameters = try builder.allocator.dupe(node.Field, &.{
            .{ .name = "request", .value = try requestType(builder) },
            .{ .name = "status", .value = try builder.path(&.{ "std", "http", "Status" }) },
            .{ .name = "body", .value = try builder.expression(.{ .const_slice = try builder.expression(.{ .primitive = .u8 }) }) },
            .{ .name = "headers", .value = try builder.expression(.{ .const_slice = try builder.path(&.{ "std", "http", "Header" }) }) },
        }),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .void }) } }),
        .body = try builder.statements(&.{
            .{ .assignment = .{ .target = try builder.path(&.{ "request", "head", "expect" }), .value = try builder.expression(.null_value) } },
            .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "request", "respond" }), &.{ try builder.identifier("body"), options }) }) },
        }),
    } };
}

fn requestType(builder: Builder) std.mem.Allocator.Error!*const node.Expression {
    return builder.expression(.{ .pointer = try builder.path(&.{ "std", "http", "Server", "Request" }) });
}

fn reply(builder: Builder, status: []const u8, message: []const u8) std.mem.Allocator.Error!node.Statement {
    return .{ .expression = try builder.expression(.{ .try_value = try invoke.response(builder, status, try builder.string(message), &.{}) }) };
}

fn reject(builder: Builder, condition: *const node.Expression, status: []const u8, message: []const u8) std.mem.Allocator.Error!node.Statement {
    return builder.branch(condition, &.{ try reply(builder, status, message), .{ .result = try builder.expression(.null_value) } }, &.{});
}
