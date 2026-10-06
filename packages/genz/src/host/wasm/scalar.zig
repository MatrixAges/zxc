const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");
const types = @import("scalar_types.zig");

pub fn lower(builder: Builder, stateful: bool) std.mem.Allocator.Error![]const node.Declaration {
    const allocator = builder.allocator;
    const input_type = try builder.path(&.{ "application", "Input" });
    const output_type = try builder.path(&.{ "application", "Output" });
    const void_type = try builder.expression(.{ .primitive = .void });
    const u32_type = try builder.expression(.{ .primitive = .u32 });
    const scalar = try builder.identifier("Scalar");
    const value = try builder.identifier("value");
    const output = try builder.identifier("output");
    const no = try builder.expression(.{ .boolean = false });
    const invalid = try builder.expression(.{ .return_value = try common.invoke(builder, "scalarInvalid") });
    const scalar_output = try builder.call(scalar, &.{output_type});

    const result = try types.select(builder, output_type, &.{
        try types.arm(builder, "void", null, try builder.integer(0)),
        try types.arm(builder, "bool", null, try builder.builtin(.intFromBool, &.{output})),
        try types.arm(builder, "int", null, output),
        try types.arm(builder, "float", null, output),
        .{ .result = try builder.expression(.unreachable_value) },
    });

    const input = try types.select(builder, input_type, &.{
        try types.arm(builder, "bool", null, try builder.expression(.{ .conditional = .{
            .condition = try builder.binary(.less_equal, value, try builder.integer(1)),
            .yes = try builder.binary(.equal, value, try builder.integer(1)),
            .no = invalid,
        } })),
        try types.arm(builder, "int", null, try builder.binary(.coalesce, try builder.call(try builder.path(&.{ "std", "math", "cast" }), &.{ input_type, value }), invalid)),
        try types.arm(builder, "float", null, value),
        .{ .result = try builder.expression(.unreachable_value) },
    });

    var declarations: std.ArrayList(node.Declaration) = .empty;

    try declarations.appendSlice(allocator, &.{
        .{ .variable = .{ .name = "scalar_result", .type_expr = scalar_output, .value = try builder.expression(.undefined_value) } },
        .{ .variable = .{ .name = "scalar_ready", .value = no } },
        try exports(builder, input_type, output_type, void_type),
    });

    try declarations.appendSlice(allocator, try types.lower(builder));

    try declarations.appendSlice(allocator, &.{
        .{ .function = .{
            .name = "scalarCall",
            .parameters = try allocator.dupe(node.Field, &.{.{ .name = "value", .value = try builder.call(scalar, &.{input_type}) }}),
            .return_type = u32_type,
            .calling_convention = try builder.expression(.{ .enum_literal = "c" }),
            .body = try builder.statements(&.{
                .{ .constant = .{ .name = "input_value", .type_expr = input_type, .value = input } },
                .{ .result = try builder.call(try builder.identifier("scalarExecute"), &.{try builder.identifier("input_value")}) },
            }),
        } },
        .{ .function = .{
            .name = "scalarCallVoid",
            .parameters = &.{},
            .return_type = u32_type,
            .calling_convention = try builder.expression(.{ .enum_literal = "c" }),
            .body = try builder.statements(&.{.{ .result = try builder.call(try builder.identifier("scalarExecute"), &.{try builder.expression(.unit)}) }}),
        } },
        .{ .function = .{
            .name = "scalarResult",
            .parameters = &.{},
            .return_type = scalar_output,
            .calling_convention = try builder.expression(.{ .enum_literal = "c" }),
            .body = try builder.statements(&.{.{ .result = try builder.expression(.{ .conditional = .{ .condition = try builder.identifier("scalar_ready"), .yes = try builder.identifier("scalar_result"), .no = try builder.integer(0) } }) }}),
        } },
        try common.function(builder, "scalarInvalid", u32_type, &.{
            try builder.branch(try builder.identifier("executing"), &.{.{ .result = try builder.integer(2) }}, &.{}),
            .{ .expression = try common.invoke(builder, "zxc_reset") },
            try common.assign(builder, "result", try builder.string("InvalidScalarInput")),
            .{ .result = try builder.integer(1) },
        }, false),
        .{ .function = .{
            .name = "scalarExecute",
            .parameters = try allocator.dupe(node.Field, &.{.{ .name = "value", .value = input_type }}),
            .return_type = u32_type,
            .body = try builder.statements(&.{
                try builder.branch(try builder.identifier("executing"), &.{.{ .result = try builder.integer(2) }}, &.{}),
                .{ .expression = try common.invoke(builder, "zxc_reset") },
                try common.assign(builder, "executing", try builder.expression(.{ .boolean = true })),
                .{ .defer_scope = try builder.statements(&.{try common.assign(builder, "executing", no)}) },
                .{ .expression = try common.failure(builder, try common.invoke(builder, "prepare"), 1) },
                try common.current(builder),
                .{ .constant = .{ .name = "output", .value = try common.failure(builder, try common.execute(builder, stateful), 1) } },
                try common.assign(builder, "scalar_result", result),
                try common.assign(builder, "scalar_ready", try builder.expression(.{ .boolean = true })),
                .{ .result = try builder.integer(0) },
            }),
        } },
    });

    return declarations.toOwnedSlice(allocator);
}

fn exports(builder: Builder, input: *const node.Expression, output: *const node.Expression, void_type: *const node.Expression) std.mem.Allocator.Error!node.Declaration {
    const supported = try builder.identifier("isScalar");

    const call = try builder.expression(.{ .conditional = .{
        .condition = try builder.binary(.equal, input, void_type),
        .yes = try builder.expression(.{ .address_of = try builder.identifier("scalarCallVoid") }),
        .no = try builder.expression(.{ .address_of = try builder.identifier("scalarCall") }),
    } });

    return .{ .comptime_scope = try builder.statements(&.{try builder.branch(try builder.binary(.logical_and, try builder.call(supported, &.{input}), try builder.call(supported, &.{output})), &.{
        .{ .expression = try builder.builtin(.@"export", &.{ call, try builder.object(&.{.{ .name = "name", .value = try builder.string("zxc_call") }}) }) },
        try builder.branch(try builder.binary(.not_equal, output, void_type), &.{.{ .expression = try builder.builtin(.@"export", &.{ try builder.expression(.{ .address_of = try builder.identifier("scalarResult") }), try builder.object(&.{.{ .name = "name", .value = try builder.string("zxc_scalar_result") }}) }) }}, &.{}),
    }, &.{})}) };
}
