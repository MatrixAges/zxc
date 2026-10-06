const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Types = @import("types.zig");
const common = @import("common.zig");

pub fn lower(types: Types, id: ir.TypeId) Types.Error!node.Declaration {
    const builder = types.builder;
    const value_type = types.values[@backingInt(id)];
    const allocator = try builder.identifier("allocator");
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    var body: std.ArrayList(node.Statement) = .empty;

    switch (value_type) {
        .task => return error.UnsupportedNodeType,
        .scalar => |scalar| {
            if (scalar != .string) try body.append(builder.allocator, .{ .discard = allocator });

            switch (scalar) {
                .void => try body.appendSlice(builder.allocator, &.{ .{ .discard = env }, .{ .discard = value }, .{ .result = try builder.expression(.unit) } }),
                .bool => try body.appendSlice(builder.allocator, &.{
                    .{ .variable = .{ .name = "result", .value = try builder.expression(.{ .boolean = false }) } },
                    try common.check(builder, "napi_get_value_bool", &.{ env, value, try common.address(builder, "result") }),
                    .{ .result = try builder.identifier("result") },
                }),
                .string => try body.append(builder.allocator, .{ .result = try builder.call(try builder.identifier("string"), &.{ allocator, env, value }) }),
                else => try body.appendSlice(builder.allocator, try @import("number.zig").lower(types, id, scalar)),
            }
        },
        .enumeration => try body.append(builder.allocator, .{ .result = try builder.binary(.coalesce, try builder.call(try builder.path(&.{ "std", "meta", "stringToEnum" }), &.{ try types.typeExpression(id), try common.invocation(builder, "string", &.{ allocator, env, value }) }), try builder.expression(.{ .error_value = "InvalidEnumMember" })) }),
        .error_set => |members| {
            try body.appendSlice(builder.allocator, &.{
                .{ .constant = .{ .name = "name", .value = try common.invocation(builder, "string", &.{ allocator, env, value }) } },
                .{ .defer_expression = try builder.call(try builder.path(&.{ "allocator", "free" }), &.{try builder.identifier("name")}) },
            });

            for (members) |member| {
                try body.append(builder.allocator, try builder.branch(try builder.call(try builder.path(&.{ "std", "mem", "eql" }), &.{ try builder.expression(.{ .primitive = .u8 }), try builder.identifier("name"), try builder.string(member) }), &.{.{ .result = try builder.field(try types.typeExpression(id), member) }}, &.{}));
            }

            try body.append(builder.allocator, .{ .result = try builder.expression(.{ .error_value = "InvalidErrorMember" }) });
        },
        .optional => |child| {
            const kind = try builder.identifier("value_kind");

            try body.appendSlice(builder.allocator, &.{
                .{ .constant = .{ .name = "value_kind", .value = try common.invocation(builder, "kind", &.{ env, value }) } },
                try builder.branch(try builder.binary(.logical_or, try builder.binary(.equal, kind, try builder.expression(.{ .enum_literal = "null" })), try builder.binary(.equal, kind, try builder.expression(.{ .enum_literal = "undefined" }))), &.{.{ .result = try builder.expression(.null_value) }}, &.{}),
                .{ .result = try common.invocation(builder, try types.name("read_", child), &.{ allocator, env, value }) },
            });
        },
        .list => |child| try body.appendSlice(builder.allocator, try @import("list.zig").read(types, child)),
        .object, .tuple => try body.appendSlice(builder.allocator, try @import("record.zig").read(types, id)),
    }

    return common.function(builder, try types.name("read_", id), try common.parameters(builder, true), try types.typeExpression(id), body.items);
}
