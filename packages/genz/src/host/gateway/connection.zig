const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn lower(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const io = try builder.path(&.{ "init", "io" });
    const err = try builder.identifier("err");
    const output = try builder.path(&.{ "output", "interface" });
    const check = try builder.expression(.{ .try_value = try builder.call(try builder.identifier("checkCanceled"), &.{ try builder.path(&.{ "input", "err" }), try builder.path(&.{ "output", "err" }) }) });

    const receive = try builder.expression(.{ .catch_scope = .{
        .value = try builder.call(try builder.path(&.{ "server", "receiveHead" }), &.{}),
        .capture = "err",
        .body = try builder.statements(&.{
            .{ .expression = check },
            try builder.branch(try builder.binary(.equal, err, try builder.expression(.{ .error_value = "HttpConnectionClosing" })), &.{.{ .result = null }}, &.{}),
            .{ .constant = .{ .name = "status", .type_expr = try builder.expression(.{ .const_slice = try builder.expression(.{ .primitive = .u8 }) }), .value = try builder.expression(.{ .conditional = .{
                .condition = try builder.binary(.equal, err, try builder.expression(.{ .error_value = "HttpHeadersOversize" })),
                .yes = try builder.string("431 Request Header Fields Too Large"),
                .no = try builder.string("400 Bad Request"),
            } }) } },
            .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.field(output, "print"), &.{ try builder.string("HTTP/1.1 {s}\r\nconnection: close\r\ncontent-length: 0\r\n\r\n"), try builder.tuple(&.{try builder.identifier("status")}) }) }) },
            .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.field(output, "flush"), &.{}) }) },
            .{ .result = null },
        }),
    } });

    const dispatch = try builder.call(try builder.path(&.{ "application", "dispatch" }), &.{
        try builder.expression(.{ .address_of = try builder.identifier("scope") }),
        io,
        try builder.path(&.{ "init", "minimal" }),
        try builder.expression(.{ .address_of = try builder.identifier("request") }),
    });

    return .{ .function = .{
        .name = "handle",
        .parameters = try builder.allocator.dupe(node.Field, &.{
            .{ .name = "init", .value = try builder.path(&.{ "std", "process", "Init" }) },
            .{ .name = "state", .value = try builder.expression(.{ .pointer = try builder.path(&.{ "application", "State" }) }) },
            .{ .name = "stream", .value = try builder.path(&.{ "std", "Io", "net", "Stream" }) },
            .{ .name = "head_buffer", .value = try builder.expression(.{ .mutable_slice = try builder.expression(.{ .primitive = .u8 }) }) },
        }),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .void }) } }),
        .body = try builder.statements(&.{
            .{ .variable = .{ .name = "output_buffer", .type_expr = try builder.expression(.{ .fixed_array_type = .{ .length = try builder.integer(4096), .element = try builder.expression(.{ .primitive = .u8 }) } }), .value = try builder.expression(.undefined_value) } },
            .{ .variable = .{ .name = "input", .value = try builder.call(try builder.path(&.{ "stream", "reader" }), &.{ io, try builder.identifier("head_buffer") }) } },
            .{ .variable = .{ .name = "output", .value = try builder.call(try builder.path(&.{ "stream", "writer" }), &.{ io, try builder.expression(.{ .address_of = try builder.identifier("output_buffer") }) }) } },
            .{ .variable = .{ .name = "server", .value = try builder.call(try builder.path(&.{ "std", "http", "Server", "init" }), &.{ try builder.expression(.{ .address_of = try builder.path(&.{ "input", "interface" }) }), try builder.expression(.{ .address_of = output }) }) } },
            .{ .variable = .{ .name = "request", .value = receive } },
            .{ .variable = .{ .name = "scope", .value = try builder.call(try builder.path(&.{ "state", "request" }), &.{}) } },
            .{ .defer_expression = try builder.call(try builder.path(&.{ "scope", "deinit" }), &.{}) },
            .{ .expression = try builder.expression(.{ .catch_scope = .{ .value = dispatch, .capture = "err", .body = try builder.statements(&.{ .{ .expression = check }, .{ .result = err } }) } }) },
            .{ .expression = check },
        }),
    } };
}

pub fn checkCanceled(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const error_type = try builder.expression(.{ .optional_type = try builder.expression(.{ .primitive = .anyerror }) });
    const canceled = try builder.expression(.{ .error_value = "Canceled" });
    const failure = try builder.statements(&.{try builder.branch(try builder.binary(.equal, try builder.identifier("err"), canceled), &.{.{ .result = canceled }}, &.{})});

    return .{ .function = .{
        .name = "checkCanceled",
        .parameters = try builder.allocator.dupe(node.Field, &.{ .{ .name = "input", .value = error_type }, .{ .name = "output", .value = error_type } }),
        .return_type = try builder.expression(.{ .error_union = .{ .errors = &.{"Canceled"}, .payload = try builder.expression(.{ .primitive = .void }) } }),
        .body = try builder.statements(&.{
            .{ .branch = .{ .condition = try builder.identifier("input"), .capture = "err", .yes = failure, .no = &.{} } },
            .{ .branch = .{ .condition = try builder.identifier("output"), .capture = "err", .yes = failure, .no = &.{} } },
        }),
    } };
}
