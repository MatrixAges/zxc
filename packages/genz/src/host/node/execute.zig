const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn lower(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    const memory = builder.allocator;
    const env = try builder.identifier("env");
    const arguments = try builder.identifier("arguments");
    const count = try builder.identifier("count");
    const data = try builder.identifier("data");
    const expected = try builder.identifier("expected");
    const busy = try builder.path(&.{ "context", "busy" });
    const void_type = try builder.expression(.{ .primitive = .void });
    const api_value = try builder.path(&.{ "api", "Value" });
    var body: std.ArrayList(node.Statement) = .empty;

    try body.appendSlice(memory, &.{
        .{ .variable = .{ .name = "arguments", .type_expr = try builder.expression(.{ .fixed_array_type = .{ .length = try builder.integer(2), .element = api_value } }), .value = try builder.expression(.undefined_value) } },
        .{ .variable = .{ .name = "count", .type_expr = try builder.expression(.{ .primitive = .usize }), .value = try builder.field(arguments, "len") } },
        .{ .variable = .{ .name = "data", .type_expr = try common.dataType(builder), .value = try builder.expression(.null_value) } },
        try common.check(builder, "napi_get_cb_info", &.{ env, try builder.identifier("info"), try builder.expression(.{ .address_of = count }), try builder.expression(.{ .address_of = arguments }), try builder.expression(.null_value), try builder.expression(.{ .address_of = data }) }),
        .{ .constant = .{ .name = "expected", .type_expr = try builder.expression(.{ .primitive = .usize }), .value = try builder.expression(.{ .conditional = .{
            .condition = try builder.binary(.equal, try builder.path(&.{ "application", "Input" }), void_type),
            .yes = try builder.integer(0),
            .no = try builder.integer(1),
        } }) } },
        try builder.branch(try builder.binary(.not_equal, count, expected), &.{.{ .result = try builder.expression(.{ .error_value = "InvalidArgumentCount" }) }}, &.{}),
        try common.context(builder),
        try builder.branch(try builder.path(&.{ "context", "closing" }), &.{.{ .result = try builder.expression(.{ .error_value = "EnvironmentClosing" }) }}, &.{}),
        try builder.branch(busy, &.{.{ .result = try builder.expression(.{ .error_value = "ReentrantInvocation" }) }}, &.{}),
    });

    if (stateful) try body.append(memory, try builder.branch(try builder.path(&.{ "context", "running" }), &.{.{ .result = try builder.expression(.{ .error_value = "PendingAsyncInvocation" }) }}, &.{}));

    try body.appendSlice(memory, &.{
        .{ .assignment = .{ .target = busy, .value = try builder.expression(.{ .boolean = true }) } },
        .{ .defer_scope = try builder.statements(&.{.{ .assignment = .{ .target = busy, .value = try builder.expression(.{ .boolean = false }) } }}) },
    });

    if (stateful) {
        try body.appendSlice(memory, &.{
            .{ .variable = .{ .name = "request", .value = try builder.call(try builder.path(&.{ "context", "state", "request" }), &.{}) } },
            .{ .defer_expression = try builder.call(try builder.path(&.{ "request", "deinit" }), &.{}) },
        });
    } else {
        try body.appendSlice(memory, &.{
            .{ .variable = .{ .name = "arena", .value = try builder.call(try builder.path(&.{ "std", "heap", "ArenaAllocator", "init" }), &.{try builder.path(&.{ "std", "heap", "page_allocator" })}) } },
            .{ .defer_expression = try builder.call(try builder.path(&.{ "arena", "deinit" }), &.{}) },
        });
    }

    const arena = if (stateful) try builder.path(&.{ "request", "arena" }) else try builder.identifier("arena");

    const argument = try builder.expression(.{ .conditional = .{
        .condition = try builder.binary(.equal, expected, try builder.integer(0)),
        .yes = try builder.expression(.null_value),
        .no = try builder.expression(.{ .index = .{ .target = arguments, .index = try builder.integer(0) } }),
    } });

    const input = try builder.identifier("input");
    const call = if (stateful) try builder.call(try builder.path(&.{ "request", "execute" }), &.{input}) else try builder.call(try builder.path(&.{ "application", "execute" }), &.{ try builder.expression(.{ .address_of = arena }), input });

    const execute = try builder.expression(.{ .conditional = .{
        .condition = try builder.binary(.logical_or, try builder.path(&.{ "application", "requires_io" }), try builder.path(&.{ "application", "requires_process" })),
        .yes = try builder.expression(.unreachable_value),
        .no = try builder.expression(.{ .try_value = call }),
    } });

    try body.appendSlice(memory, &.{
        .{ .constant = .{ .name = "input", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "napi", "read" }), &.{ try builder.call(try builder.field(arena, "allocator"), &.{}), env, argument }) }) } },
        .{ .constant = .{ .name = "output", .value = execute } },
        .{ .result = try builder.call(try builder.path(&.{ "napi", "write" }), &.{ env, try builder.identifier("output") }) },
    });

    return .{ .function = .{
        .name = "execute",
        .parameters = try common.parameters(builder),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = api_value } }),
        .body = try body.toOwnedSlice(memory),
    } };
}
