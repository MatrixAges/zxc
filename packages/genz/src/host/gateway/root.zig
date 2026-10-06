const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn render(allocator: std.mem.Allocator) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    const io = try builder.path(&.{ "init", "io" });
    const gpa = try builder.path(&.{ "init", "gpa" });
    const state = try builder.identifier("state");
    const err = try builder.identifier("err");
    const address = try builder.call(try builder.path(&.{ "std", "Io", "net", "IpAddress", "parseLiteral" }), &.{try builder.path(&.{ "application", "listen" })});
    const listen = try builder.call(try builder.path(&.{ "address", "listen" }), &.{ io, try builder.object(&.{.{ .name = "reuse_address", .value = try builder.expression(.{ .boolean = true }) }}) });
    const handle = try builder.call(try builder.identifier("handle"), &.{ try builder.identifier("init"), try builder.expression(.{ .address_of = state }), try builder.identifier("stream"), try builder.identifier("head_buffer") });

    const failure = try builder.expression(.{ .catch_scope = .{ .value = handle, .capture = "err", .body = try builder.statements(&.{
        try builder.branch(try builder.binary(.logical_or, try builder.binary(.equal, err, try builder.expression(.{ .error_value = "OutOfMemory" })), try builder.binary(.equal, err, try builder.expression(.{ .error_value = "Canceled" }))), &.{.{ .result = err }}, &.{}),
        .{ .expression = try builder.call(try builder.path(&.{ "std", "log", "err" }), &.{ try builder.string("Gateway connection failed: {s}"), try builder.tuple(&.{try builder.builtin(.errorName, &.{err})}) }) },
    }) } });

    const main: node.Declaration = .{ .function = .{
        .name = "main",
        .parameters = try builder.allocator.dupe(node.Field, &.{.{ .name = "init", .value = try builder.path(&.{ "std", "process", "Init" }) }}),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .void }) } }),
        .body = try builder.statements(&.{
            .{ .constant = .{ .name = "address", .value = try builder.expression(.{ .try_value = address }) } },
            .{ .variable = .{ .name = "listener", .value = try builder.expression(.{ .try_value = listen }) } },
            .{ .defer_expression = try builder.call(try builder.path(&.{ "listener", "deinit" }), &.{io}) },
            .{ .variable = .{ .name = "state", .value = try builder.expression(.{ .object = .{ .type_expr = try builder.path(&.{ "application", "State" }), .fields = try builder.allocator.dupe(node.Field, &.{.{ .name = "arena", .value = try builder.path(&.{ "init", "arena" }) }}) } }) } },
            .{ .defer_expression = try builder.call(try builder.path(&.{ "state", "deinit" }), &.{}) },
            .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "state", "initialize" }), &.{}) }) },
            .{ .constant = .{ .name = "head_buffer", .value = try builder.expression(.{ .try_value = try builder.call(try builder.field(gpa, "alloc"), &.{ try builder.expression(.{ .primitive = .u8 }), try builder.path(&.{ "application", "max_header_bytes" }) }) }) } },
            .{ .defer_expression = try builder.call(try builder.field(gpa, "free"), &.{try builder.identifier("head_buffer")}) },
            .{ .while_loop = .{ .condition = try builder.expression(.{ .boolean = true }), .body = try builder.statements(&.{
                .{ .constant = .{ .name = "stream", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "listener", "accept" }), &.{io}) }) } },
                .{ .defer_scope = try builder.statements(&.{
                    .{ .discard_error = try builder.call(try builder.path(&.{ "stream", "shutdown" }), &.{ io, try builder.expression(.{ .enum_literal = "both" }) }) },
                    .{ .expression = try builder.call(try builder.path(&.{ "stream", "close" }), &.{io}) },
                }) },
                .{ .expression = failure },
                .{ .expression = try builder.call(try builder.path(&.{ "state", "releaseRetired" }), &.{}) },
            }) } },
        }),
        .exported = true,
    } };

    return @import("../../render.zig").render(allocator, &.{
        .{ .constant = .{ .name = "std", .value = try builder.builtin(.import, &.{try builder.string("std")}) } },
        .{ .constant = .{ .name = "application", .value = try builder.builtin(.import, &.{try builder.string("application")}) } },
        main,
        try @import("connection.zig").lower(builder),
        try @import("connection.zig").checkCanceled(builder),
    });
}
