const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn reset(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const empty = try builder.expression(.{ .address_of = try builder.tuple(&.{}) });
    const no = try builder.expression(.{ .boolean = false });

    return common.function(builder, "zxc_reset", try builder.expression(.{ .primitive = .void }), &.{
        try builder.branch(try builder.identifier("executing"), &.{.{ .result = null }}, &.{}),
        .{ .branch = .{ .condition = try builder.identifier("request"), .capture = "value", .capture_reference = true, .yes = try builder.statements(&.{.{ .expression = try builder.call(try builder.path(&.{ "value", "deinit" }), &.{}) }}), .no = &.{} } },
        .{ .expression = try builder.call(try builder.path(&.{ "std", "heap", "wasm_allocator", "free" }), &.{try builder.identifier("input_storage")}) },
        try common.assign(builder, "request", try builder.expression(.null_value)),
        try common.assign(builder, "input_storage", empty),
        try common.assign(builder, "input", empty),
        try common.assign(builder, "result", empty),
        try common.assign(builder, "ready", no),
        try common.assign(builder, "scalar_ready", no),
    }, true);
}

pub fn deinit(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    var body: std.ArrayList(node.Statement) = .empty;
    const allocator = builder.allocator;

    try body.appendSlice(allocator, &.{
        try builder.branch(try builder.identifier("executing"), &.{.{ .result = null }}, &.{}),
        .{ .expression = try common.invoke(builder, "zxc_reset") },
    });

    if (stateful) try body.append(allocator, try builder.branch(try builder.identifier("initialized"), &.{.{ .expression = try builder.call(try builder.path(&.{ "state", "deinit" }), &.{}) }}, &.{}));

    try body.appendSlice(allocator, &.{
        .{ .expression = try builder.call(try builder.path(&.{ "state_arena", "deinit" }), &.{}) },
        try common.assign(builder, "state_arena", try common.arena(builder)),
        try common.assign(builder, "initialized", try builder.expression(.{ .boolean = false })),
    });

    return common.function(builder, "zxc_deinit", try builder.expression(.{ .primitive = .void }), body.items, true);
}

pub fn prepare(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    const payload = try builder.expression(.{ .primitive = .void });
    const result = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = payload } });

    if (!stateful) return common.function(builder, "prepare", result, &.{try common.assign(builder, "request", try builder.object(&.{.{ .name = "arena", .value = try common.arena(builder) }}))}, false);

    const initialize = try builder.expression(.{ .catch_scope = .{
        .value = try builder.call(try builder.path(&.{ "state", "initialize" }), &.{}),
        .capture = "err",
        .body = try builder.statements(&.{
            .{ .expression = try builder.call(try builder.path(&.{ "state", "deinit" }), &.{}) },
            .{ .discard = try builder.call(try builder.path(&.{ "state_arena", "reset" }), &.{try builder.expression(.{ .enum_literal = "free_all" })}) },
            .{ .result = try builder.identifier("err") },
        }),
    } });

    return common.function(builder, "prepare", result, &.{
        try builder.branch(try builder.expression(.{ .unary = .{ .operator = .not, .operand = try builder.identifier("initialized") } }), &.{
            try common.assign(builder, "state", try builder.object(&.{.{ .name = "arena", .value = try builder.expression(.{ .address_of = try builder.identifier("state_arena") }) }})),
            .{ .expression = initialize },
            try common.assign(builder, "initialized", try builder.expression(.{ .boolean = true })),
        }, &.{}),
        try common.assign(builder, "request", try builder.call(try builder.path(&.{ "state", "request" }), &.{})),
    }, false);
}
