const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Types = @import("types.zig");
const common = @import("common.zig");

pub fn lower(types: Types, id: ir.TypeId) Types.Error!node.Declaration {
    const builder = types.builder;
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    const result = try builder.identifier("result");
    const address = try common.address(builder, "result");
    const nil = try builder.expression(.null_value);
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(builder.allocator, .{ .variable = .{ .name = "result", .type_expr = try builder.path(&.{ "api", "Value" }), .value = nil } });

    switch (types.values.at(@backingInt(id))) {
        .task, .native_reference => return error.UnsupportedNodeType,
        .scalar => |scalar| switch (scalar) {
            .void => try body.appendSlice(builder.allocator, &.{
                .{ .discard = value },
                try common.check(builder, "napi_get_undefined", &.{ env, address }),
            }),
            .bool => try body.append(builder.allocator, try common.check(builder, "napi_get_boolean", &.{ env, value, address })),
            .u64, .i64 => try body.append(builder.allocator, try common.check(builder, if (scalar == .i64) "napi_create_bigint_int64" else "napi_create_bigint_uint64", &.{ env, value, address })),
            .f32, .f64 => try body.append(builder.allocator, try common.check(builder, "napi_create_double", &.{ env, value, address })),
            .string => try body.append(builder.allocator, try common.check(builder, "napi_create_string_utf8", &.{ env, try builder.field(value, "ptr"), try builder.field(value, "len"), address })),
            else => try body.append(builder.allocator, try common.check(builder, "napi_create_double", &.{ env, try builder.builtin(.floatFromInt, &.{value}), address })),
        },
        .enumeration, .error_set => {
            try body.appendSlice(builder.allocator, &.{
                .{ .constant = .{ .name = "name", .value = try builder.builtin(if (types.values.at(@backingInt(id)) == .enumeration) .tagName else .errorName, &.{value}) } },
                try common.check(builder, "napi_create_string_utf8", &.{ env, try builder.path(&.{ "name", "ptr" }), try builder.path(&.{ "name", "len" }), address }),
            });
        },
        .optional => |child| try body.append(builder.allocator, .{ .branch = .{
            .condition = value,
            .capture = "child",
            .yes = try builder.statements(&.{.{ .result = try builder.call(try builder.identifier(try types.name("write_", child)), &.{ env, try builder.identifier("child") }) }}),
            .no = try builder.statements(&.{try common.check(builder, "napi_get_null", &.{ env, address })}),
        } }),
        .list => |child| {
            if (types.values.at(@backingInt(child)) == .scalar and types.values.at(@backingInt(child)).scalar == .u8) {
                try body.append(builder.allocator, try common.check(builder, "napi_create_buffer_copy", &.{ env, try builder.field(value, "len"), try builder.field(value, "ptr"), nil, address }));
            } else {
                try body.appendSlice(builder.allocator, &.{
                    try common.check(builder, "napi_create_array_with_length", &.{ env, try builder.field(value, "len"), address }),
                    .{ .for_loop = .{ .iterable = value, .capture = "item", .index_capture = "index", .body = try builder.statements(&.{
                        try common.check(builder, "napi_set_element", &.{ env, result, try builder.builtin(.intCast, &.{try builder.identifier("index")}), try common.invocation(builder, try types.name("write_", child), &.{ env, try builder.identifier("item") }) }),
                    }) } },
                });
            }
        },
        .object, .tuple => try body.appendSlice(builder.allocator, try @import("record.zig").write(types, id)),
    }

    try body.append(builder.allocator, .{ .result = result });

    return common.function(builder, try types.name("write_", id), try builder.allocator.dupe(node.Field, &.{
        .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) },
        .{ .name = "value", .value = try types.typeExpression(id) },
    }), try builder.path(&.{ "api", "Value" }), body.items);
}
