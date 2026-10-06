const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Types = @import("types.zig");
const common = @import("common.zig");

pub fn lower(types: Types, id: ir.TypeId, scalar: ir.Scalar) std.mem.Allocator.Error![]const node.Statement {
    const builder = types.builder;
    const env = try builder.identifier("env");
    const value = try builder.identifier("value");
    const result = try builder.identifier("result");
    const target = try types.typeExpression(id);

    if (scalar == .u64 or scalar == .i64) return builder.statements(&.{
        .{ .variable = .{ .name = "result", .type_expr = target, .value = try builder.expression(.undefined_value) } },
        .{ .variable = .{ .name = "lossless", .value = try builder.expression(.{ .boolean = false }) } },
        try common.check(builder, if (scalar == .i64) "napi_get_value_bigint_int64" else "napi_get_value_bigint_uint64", &.{ env, value, try common.address(builder, "result"), try common.address(builder, "lossless") }),
        try common.failure(builder, try builder.expression(.{ .unary = .{ .operator = .not, .operand = try builder.identifier("lossless") } }), "IntegerOutOfRange"),
        .{ .result = result },
    });

    var body: std.ArrayList(node.Statement) = .empty;

    try body.appendSlice(builder.allocator, &.{
        .{ .variable = .{ .name = "result", .type_expr = try builder.expression(.{ .primitive = .f64 }), .value = try builder.expression(.undefined_value) } },
        try common.check(builder, "napi_get_value_double", &.{ env, value, try common.address(builder, "result") }),
    });

    if (scalar == .f32 or scalar == .f64) {
        try body.append(builder.allocator, .{ .result = try builder.builtin(.floatCast, &.{result}) });
    } else {
        const finite = try builder.call(try builder.path(&.{ "std", "math", "isFinite" }), &.{result});
        const integral = try builder.binary(.not_equal, try builder.builtin(.trunc, &.{result}), result);
        const low = try builder.binary(.less, result, try builder.call(try builder.path(&.{ "std", "math", "minInt" }), &.{target}));
        const high = try builder.binary(.greater, result, try builder.call(try builder.path(&.{ "std", "math", "maxInt" }), &.{target}));
        const invalid = try builder.binary(.logical_or, try builder.binary(.logical_or, try builder.binary(.logical_or, try builder.expression(.{ .unary = .{ .operator = .not, .operand = finite } }), integral), low), high);

        try body.appendSlice(builder.allocator, &.{
            try common.failure(builder, invalid, "IntegerOutOfRange"),
            .{ .result = try builder.builtin(.intFromFloat, &.{result}) },
        });
    }

    return body.toOwnedSlice(builder.allocator);
}
