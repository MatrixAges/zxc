const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn lower(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    const memory = builder.allocator;
    const env = try builder.identifier("env");
    const context = try builder.identifier("context");
    const exports = try builder.identifier("exports");
    const nil = try builder.expression(.null_value);
    var body: std.ArrayList(node.Statement) = .empty;

    try body.appendSlice(memory, &.{
        .{ .constant = .{ .name = "context", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "std", "heap", "page_allocator", "create" }), &.{try builder.identifier("Context")}) }) } },
        .{ .assignment = .{ .target = try builder.expression(.{ .dereference = context }), .value = try builder.object(&.{
            .{ .name = "arena", .value = try builder.call(try builder.path(&.{ "std", "heap", "ArenaAllocator", "init" }), &.{try builder.path(&.{ "std", "heap", "page_allocator" })}) },
            .{ .name = "env", .value = env },
        }) } },
        .{ .defer_expression = try builder.call(try builder.field(context, "release"), &.{}) },
    });

    if (stateful) try body.appendSlice(memory, &.{
        .{ .assignment = .{ .target = try builder.field(context, "state"), .value = try builder.object(&.{.{ .name = "arena", .value = try builder.expression(.{ .address_of = try builder.field(context, "arena") }) }}) } },
        .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "context", "state", "initialize" }), &.{}) }) },
    });

    try body.appendSlice(memory, &.{
        try common.check(builder, "napi_add_env_cleanup_hook", &.{ env, try builder.path(&.{ "Context", "cleanup" }), context }),
        .{ .assignment = .{ .target = try builder.field(context, "hooked"), .value = try builder.expression(.{ .boolean = true }) } },
    });

    for ([_]struct { name: []const u8, callback: []const u8 }{
        .{ .name = "execute", .callback = "callback" },
        .{ .name = "executeTask", .callback = "enqueue" },
    }) |binding| {
        const function = try builder.identifier("function");

        const property = try builder.expression(.{ .object = .{ .type_expr = try builder.path(&.{ "api", "Property" }), .fields = try memory.dupe(node.Field, &.{
            .{ .name = "utf8name", .value = try builder.string(binding.name) },
            .{ .name = "value", .value = function },
        }) } });

        try body.append(memory, .{ .scope = try builder.statements(&.{
            .{ .variable = .{ .name = "function", .type_expr = try builder.path(&.{ "api", "Value" }), .value = nil } },
            try common.check(builder, "napi_create_function", &.{ env, try builder.string(binding.name), try builder.integer(binding.name.len), try builder.identifier(binding.callback), context, try builder.expression(.{ .address_of = function }) }),
            try common.check(builder, "napi_add_finalizer", &.{ env, function, context, try builder.identifier("finalize"), nil, nil }),
            .{ .expression = try builder.call(try builder.field(context, "retain"), &.{}) },
            .{ .constant = .{ .name = "property", .value = property } },
            try common.check(builder, "napi_define_properties", &.{ env, exports, try builder.integer(1), try builder.builtin(.ptrCast, &.{try builder.expression(.{ .address_of = try builder.identifier("property") })}) }),
        }) });
    }

    try body.append(memory, .{ .result = exports });

    return .{ .function = .{
        .name = "register",
        .parameters = try parameters(builder),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.path(&.{ "api", "Value" }) } }),
        .body = try body.toOwnedSlice(memory),
    } };
}

pub fn entry(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const env = try builder.identifier("env");
    const register = try builder.call(try builder.identifier("register"), &.{ env, try builder.identifier("exports") });

    return .{ .function = .{
        .name = "napi_register_module_v1",
        .parameters = try parameters(builder),
        .return_type = try builder.path(&.{ "api", "Value" }),
        .abi_export = true,
        .body = try builder.statements(&.{.{ .result = try builder.expression(.{ .catch_scope = .{ .value = register, .capture = "err", .body = try builder.statements(&.{.{ .result = try builder.call(try builder.path(&.{ "napi", "fail" }), &.{ env, try builder.identifier("err") }) }}) } }) }}),
    } };
}

fn parameters(builder: Builder) std.mem.Allocator.Error![]const node.Field {
    return builder.allocator.dupe(node.Field, &.{
        .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) },
        .{ .name = "exports", .value = try builder.path(&.{ "api", "Value" }) },
    });
}
