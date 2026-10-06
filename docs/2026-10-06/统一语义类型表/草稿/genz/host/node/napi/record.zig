const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Types = @import("types.zig");
const common = @import("common.zig");

pub fn read(types: Types, id: ir.TypeId) std.mem.Allocator.Error![]const node.Statement {
    const builder = types.builder;
    const descriptor = types.values.at(@backingInt(id));
    const tuple = descriptor == .tuple;
    const fields = if (tuple) descriptor.tuple.len else descriptor.object.len;
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    const allocator = try builder.identifier("allocator");
    const result = try builder.identifier("result");
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(builder.allocator, if (tuple)
        try common.failure(builder, try builder.binary(.not_equal, try common.invocation(builder, "length", &.{ env, value }), try builder.integer(fields)), "InvalidTupleLength")
    else
        try common.failure(builder, try builder.binary(.not_equal, try common.invocation(builder, "kind", &.{ env, value }), try builder.expression(.{ .enum_literal = "object" })), "ExpectedObject"));
    try body.append(builder.allocator, .{ .constant = .{ .name = "result", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "allocator", "create" }), &.{try types.layout(id)}) }) } });

    for (0..fields) |index| {
        const name = if (tuple) try std.fmt.allocPrint(builder.allocator, "{d}", .{index}) else descriptor.object.at(index).name;
        const child = if (tuple) descriptor.tuple.at(index) else descriptor.object.at(index).type_id;
        const key = if (tuple) try builder.integer(index) else try builder.string(try std.mem.concat(builder.allocator, u8, &.{ name, "\x00" }));

        try body.append(builder.allocator, .{ .scope = try builder.statements(&.{
            .{ .variable = .{ .name = "item", .type_expr = try builder.path(&.{ "api", "Value" }), .value = try builder.expression(.null_value) } },
            try common.check(builder, if (tuple) "napi_get_element" else "napi_get_named_property", &.{ env, value, key, try common.address(builder, "item") }),
            .{ .assignment = .{ .target = try builder.field(result, name), .value = try common.invocation(builder, try types.name("read_", child), &.{ allocator, env, try builder.identifier("item") }) } },
        }) });
    }

    try body.append(builder.allocator, .{ .result = result });

    return body.toOwnedSlice(builder.allocator);
}

pub fn write(types: Types, id: ir.TypeId) std.mem.Allocator.Error![]const node.Statement {
    const builder = types.builder;
    const descriptor = types.values.at(@backingInt(id));
    const tuple = descriptor == .tuple;
    const fields = if (tuple) descriptor.tuple.len else descriptor.object.len;
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    const result = try builder.identifier("result");
    var body: std.ArrayList(node.Statement) = .empty;

    if (fields == 0) try body.append(builder.allocator, .{ .discard = value });

    try body.append(builder.allocator, if (tuple)
        try common.check(builder, "napi_create_array_with_length", &.{ env, try builder.integer(fields), try common.address(builder, "result") })
    else
        try common.check(builder, "napi_create_object", &.{ env, try common.address(builder, "result") }));

    for (0..fields) |index| {
        const name = if (tuple) try std.fmt.allocPrint(builder.allocator, "{d}", .{index}) else descriptor.object.at(index).name;
        const child = if (tuple) descriptor.tuple.at(index) else descriptor.object.at(index).type_id;
        var field: std.ArrayList(node.Statement) = .empty;

        try field.append(builder.allocator, .{ .constant = .{ .name = "item", .value = try common.invocation(builder, try types.name("write_", child), &.{ env, try builder.field(value, name) }) } });

        if (tuple) {
            try field.append(builder.allocator, try common.check(builder, "napi_set_element", &.{ env, result, try builder.integer(index), try builder.identifier("item") }));
        } else {
            try field.appendSlice(builder.allocator, &.{
                .{ .constant = .{ .name = "property", .type_expr = try builder.path(&.{ "api", "Property" }), .value = try builder.object(&.{
                    .{ .name = "utf8name", .value = try builder.string(try std.mem.concat(builder.allocator, u8, &.{ name, "\x00" })) },
                    .{ .name = "value", .value = try builder.identifier("item") },
                }) } },
                try common.check(builder, "napi_define_properties", &.{ env, result, try builder.integer(1), try builder.builtin(.ptrCast, &.{try common.address(builder, "property")}) }),
            });
        }

        try body.append(builder.allocator, .{ .scope = try field.toOwnedSlice(builder.allocator) });
    }

    return body.toOwnedSlice(builder.allocator);
}
