const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn select(builder: Builder, type_expr: *const node.Expression, arms: []const node.SelectionArm) std.mem.Allocator.Error!*const node.Expression {
    return builder.expression(.{ .selection = .{ .subject = try builder.builtin(.typeInfo, &.{type_expr}), .arms = try builder.allocator.dupe(node.SelectionArm, arms) } });
}

pub fn arm(builder: Builder, name: []const u8, capture: ?[]const u8, result: *const node.Expression) std.mem.Allocator.Error!node.SelectionArm {
    return .{ .value = try builder.expression(.{ .enum_literal = name }), .capture = capture, .result = result };
}

pub fn lower(builder: Builder) std.mem.Allocator.Error![]const node.Declaration {
    const t = try builder.identifier("T");
    const bits = try builder.path(&.{ "value", "bits" });
    const signedness = try builder.path(&.{ "value", "signedness" });
    const yes = try builder.expression(.{ .boolean = true });
    const parameters = try builder.allocator.dupe(node.Field, &.{.{ .name = "T", .value = try builder.expression(.{ .primitive = .type }), .comptime_parameter = true }});

    const is_scalar = try select(builder, t, &.{
        try arm(builder, "void", null, yes),
        try arm(builder, "bool", null, yes),
        try arm(builder, "int", "value", try builder.binary(.less_equal, bits, try builder.integer(64))),
        try arm(builder, "float", "value", try builder.binary(.logical_or, try builder.binary(.equal, bits, try builder.integer(32)), try builder.binary(.equal, bits, try builder.integer(64)))),
        .{ .result = try builder.expression(.{ .boolean = false }) },
    });

    const scalar = try select(builder, t, &.{
        try arm(builder, "int", "value", try builder.expression(.{ .conditional = .{
            .condition = try builder.binary(.less_equal, bits, try builder.integer(32)),
            .yes = try builder.builtin(.Int, &.{ signedness, try builder.integer(32) }),
            .no = try builder.builtin(.Int, &.{ signedness, try builder.integer(64) }),
        } })),
        try arm(builder, "float", null, t),
        .{ .result = try builder.expression(.{ .primitive = .u32 }) },
    });

    return builder.allocator.dupe(node.Declaration, &.{
        .{ .function = .{ .name = "isScalar", .parameters = parameters, .return_type = try builder.expression(.{ .primitive = .bool }), .body = try builder.statements(&.{.{ .result = is_scalar }}) } },
        .{ .function = .{ .name = "Scalar", .parameters = parameters, .return_type = try builder.expression(.{ .primitive = .type }), .body = try builder.statements(&.{.{ .result = scalar }}) } },
    });
}
