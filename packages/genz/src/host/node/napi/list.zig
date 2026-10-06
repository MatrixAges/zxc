const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Types = @import("types.zig");
const common = @import("common.zig");

pub fn read(types: Types, child: ir.TypeId) std.mem.Allocator.Error![]const node.Statement {
    const builder = types.builder;
    const allocator = try builder.identifier("allocator");
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    const count = try builder.identifier("count");
    const result = try builder.identifier("result");
    var body: std.ArrayList(node.Statement) = .empty;

    if (types.values[@backingInt(child)] == .scalar and types.values[@backingInt(child)].scalar == .u8) {
        try body.appendSlice(builder.allocator, &.{
            .{ .variable = .{ .name = "is_typed", .value = try builder.expression(.{ .boolean = false }) } },
            try common.check(builder, "napi_is_typedarray", &.{ env, value, try common.address(builder, "is_typed") }),
            try builder.branch(try builder.identifier("is_typed"), try bytes(types), &.{}),
        });
    }

    try body.appendSlice(builder.allocator, &.{
        .{ .constant = .{ .name = "count", .value = try common.invocation(builder, "length", &.{ env, value }) } },
        .{ .constant = .{ .name = "result", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "allocator", "alloc" }), &.{ try types.typeExpression(child), count }) }) } },
        .{ .for_loop = .{
            .iterable = result,
            .capture = "item",
            .capture_reference = true,
            .index_capture = "index",
            .body = try builder.statements(&.{
                .{ .variable = .{ .name = "input", .type_expr = try builder.path(&.{ "api", "Value" }), .value = try builder.expression(.null_value) } },
                try common.check(builder, "napi_get_element", &.{ env, value, try builder.builtin(.intCast, &.{try builder.identifier("index")}), try common.address(builder, "input") }),
                .{ .assignment = .{ .target = try builder.expression(.{ .dereference = try builder.identifier("item") }), .value = try common.invocation(builder, try types.name("read_", child), &.{ allocator, env, try builder.identifier("input") }) } },
            }),
        } },
        .{ .result = result },
    });

    return body.toOwnedSlice(builder.allocator);
}

fn bytes(types: Types) std.mem.Allocator.Error![]const node.Statement {
    const builder = types.builder;
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    const kind = try builder.identifier("array_kind");
    const count = try builder.identifier("byte_count");
    const nil = try builder.expression(.null_value);
    const zero = try builder.integer(0);
    const byte = try builder.expression(.{ .primitive = .u8 });
    const usize_type = try builder.expression(.{ .primitive = .usize });

    return builder.statements(&.{
        .{ .variable = .{ .name = "array_kind", .type_expr = try builder.identifier("c_int"), .value = zero } },
        .{ .variable = .{ .name = "byte_count", .type_expr = usize_type, .value = zero } },
        .{ .variable = .{ .name = "bytes", .type_expr = try builder.expression(.{ .optional_type = try builder.expression(.{ .many_pointer = byte }) }), .value = nil } },
        .{ .variable = .{ .name = "buffer", .type_expr = try builder.path(&.{ "api", "Value" }), .value = nil } },
        .{ .variable = .{ .name = "offset", .type_expr = usize_type, .value = zero } },
        try common.check(builder, "napi_get_typedarray_info", &.{ env, value, try common.address(builder, "array_kind"), try common.address(builder, "byte_count"), try common.address(builder, "bytes"), try common.address(builder, "buffer"), try common.address(builder, "offset") }),
        try common.failure(builder, try builder.binary(.logical_and, try builder.binary(.not_equal, kind, try builder.integer(1)), try builder.binary(.not_equal, kind, try builder.integer(2))), "ExpectedByteArray"),
        .{ .result = try builder.expression(.{ .conditional = .{
            .condition = try builder.binary(.equal, count, zero),
            .yes = try builder.expression(.{ .address_of = try builder.tuple(&.{}) }),
            .no = try builder.call(try builder.path(&.{ "allocator", "dupe" }), &.{ byte, try builder.expression(.{ .slice = .{ .target = try builder.expression(.{ .optional_unwrap = try builder.identifier("bytes") }), .start = zero, .end = count } }) }),
        } }) },
    });
}
