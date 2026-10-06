const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn execute(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const no = try builder.expression(.{ .boolean = false });

    return common.function(builder, "zxc_execute", try builder.expression(.{ .primitive = .u32 }), &.{
        try builder.branch(try builder.identifier("executing"), &.{.{ .result = try builder.integer(2) }}, &.{}),
        try builder.branch(try builder.expression(.{ .unary = .{ .operator = .not, .operand = try builder.identifier("ready") } }), &.{
            try common.assign(builder, "result", try builder.string("InputNotPrepared")),
            .{ .result = try builder.integer(1) },
        }, &.{}),
        try common.assign(builder, "ready", no),
        try common.assign(builder, "executing", try builder.expression(.{ .boolean = true })),
        .{ .defer_scope = try builder.statements(&.{try common.assign(builder, "executing", no)}) },
        .{ .expression = try common.failure(builder, try common.invoke(builder, "run"), 1) },
        .{ .result = try builder.integer(0) },
    }, true);
}

pub fn run(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    const void_type = try builder.expression(.{ .primitive = .void });
    const input_type = try builder.path(&.{ "application", "Input" });
    const allocator = try builder.identifier("allocator");

    const empty = try builder.expression(.{ .block = .{ .label = "value", .statements = try builder.statements(&.{
        try builder.branch(try builder.binary(.not_equal, try builder.path(&.{ "input", "len" }), try builder.integer(0)), &.{.{ .result = try builder.expression(.{ .error_value = "ExpectedNoInput" }) }}, &.{}),
        .{ .break_value = .{ .label = "value", .value = try builder.expression(.unit) } },
    }) } });

    const parse = try builder.call(try builder.path(&.{ "std", "json", "parseFromSliceLeaky" }), &.{ input_type, allocator, try builder.identifier("input"), try builder.object(&.{.{ .name = "allocate", .value = try builder.expression(.{ .enum_literal = "alloc_always" }) }}) });

    const encoded = try builder.expression(.{ .conditional = .{
        .condition = try builder.binary(.equal, try builder.path(&.{ "application", "Output" }), void_type),
        .yes = try builder.string("null"),
        .no = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "std", "json", "Stringify", "valueAlloc" }), &.{ allocator, try builder.identifier("output"), try builder.object(&.{}) }) }),
    } });

    const emit = try builder.field(try builder.builtin(.import, &.{try builder.string("result.zig")}), "emit");

    return common.function(builder, "run", try builder.expression(.{ .error_union = .{ .inferred = true, .payload = void_type } }), &.{
        try common.current(builder),
        .{ .constant = .{ .name = "allocator", .value = try builder.call(try builder.path(&.{ "current", "arena", "allocator" }), &.{}) } },
        .{ .constant = .{ .name = "value", .type_expr = input_type, .value = try builder.expression(.{ .conditional = .{ .condition = try builder.binary(.equal, input_type, void_type), .yes = empty, .no = try builder.expression(.{ .try_value = parse }) } }) } },
        .{ .constant = .{ .name = "output", .value = try builder.expression(.{ .try_value = try common.execute(builder, stateful) }) } },
        try common.assign(builder, "result", try builder.expression(.{ .conditional = .{ .condition = emit, .yes = encoded, .no = try builder.string("") } })),
    }, false);
}
