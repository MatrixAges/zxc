const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn lower(builder: Builder) std.mem.Allocator.Error!node.Statement {
    const input_type = try builder.path(&.{ "application", "Input" });
    const length = try builder.path(&.{ "args", "len" });
    const requires_process = try builder.path(&.{ "application", "requires_process" });

    const empty = try builder.expression(.{ .block = .{ .label = "input", .statements = try builder.statements(&.{
        try builder.branch(try builder.binary(.logical_and, try builder.expression(.{ .unary = .{ .operator = .not, .operand = requires_process } }), try builder.binary(.not_equal, length, try builder.integer(1))), &.{.{ .result = try builder.expression(.{ .error_value = "ExpectedNoArguments" }) }}, &.{}),
        .{ .break_value = .{ .label = "input", .value = try builder.expression(.unit) } },
    }) } });

    const parse = try builder.call(try builder.path(&.{ "std", "json", "parseFromSliceLeaky" }), &.{
        input_type,
        try builder.identifier("allocator"),
        try builder.expression(.{ .index = .{ .target = try builder.identifier("args"), .index = try builder.integer(1) } }),
        try builder.object(&.{.{ .name = "allocate", .value = try builder.expression(.{ .enum_literal = "alloc_always" }) }}),
    });

    const json = try builder.expression(.{ .block = .{ .label = "input", .statements = try builder.statements(&.{
        try builder.branch(try builder.binary(.not_equal, length, try builder.integer(2)), &.{.{ .result = try builder.expression(.{ .error_value = "ExpectedJsonInput" }) }}, &.{}),
        .{ .break_value = .{ .label = "input", .value = try builder.expression(.{ .try_value = parse }) } },
    }) } });

    return .{ .constant = .{
        .name = "input",
        .type_expr = input_type,
        .value = try builder.expression(.{ .conditional = .{
            .condition = try builder.binary(.equal, input_type, try builder.expression(.{ .primitive = .void })),
            .yes = empty,
            .no = json,
        } }),
    } };
}
