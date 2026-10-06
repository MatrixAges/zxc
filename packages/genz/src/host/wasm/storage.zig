const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn lower(builder: Builder, stateful: bool) std.mem.Allocator.Error![]const node.Declaration {
    const void_type = try builder.expression(.{ .primitive = .void });
    const mutable_bytes = try builder.expression(.{ .mutable_slice = try builder.expression(.{ .primitive = .u8 }) });
    const empty = try builder.expression(.{ .address_of = try builder.tuple(&.{}) });
    const no = try builder.expression(.{ .boolean = false });

    const request = if (stateful) try builder.path(&.{ "State", "Request" }) else try builder.expression(.{ .container_type = .{
        .fields = try builder.allocator.dupe(node.Field, &.{.{ .name = "arena", .value = try builder.path(&.{ "std", "heap", "ArenaAllocator" }) }}),
        .declarations = try builder.allocator.dupe(node.Declaration, &.{.{ .function = .{
            .name = "deinit",
            .parameters = try builder.allocator.dupe(node.Field, &.{.{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.builtin(.This, &.{}) }) }}),
            .return_type = void_type,
            .body = try builder.statements(&.{.{ .expression = try builder.call(try builder.path(&.{ "self", "arena", "deinit" }), &.{}) }}),
        } }}),
    } });

    return builder.allocator.dupe(node.Declaration, &.{
        .{ .constant = .{ .name = "std", .value = try builder.builtin(.import, &.{try builder.string("std")}) } },
        .{ .constant = .{ .name = "application", .value = try builder.builtin(.import, &.{try builder.string("application")}) } },
        .{ .constant = .{ .name = "State", .value = if (stateful) try builder.builtin(.import, &.{try builder.string("zxc_state")}) else void_type } },
        .{ .constant = .{ .name = "Request", .value = request } },
        .{ .variable = .{ .name = "state_arena", .value = try common.arena(builder) } },
        .{ .variable = .{ .name = "state", .type_expr = try builder.identifier("State"), .value = try builder.expression(.undefined_value) } },
        .{ .variable = .{ .name = "initialized", .value = no } },
        .{ .variable = .{ .name = "request", .type_expr = try builder.expression(.{ .optional_type = try builder.identifier("Request") }), .value = try builder.expression(.null_value) } },
        .{ .variable = .{ .name = "input_storage", .type_expr = mutable_bytes, .value = empty } },
        .{ .variable = .{ .name = "input", .type_expr = mutable_bytes, .value = empty } },
        .{ .variable = .{ .name = "result", .type_expr = try builder.expression(.{ .const_slice = try builder.expression(.{ .primitive = .u8 }) }), .value = empty } },
        .{ .variable = .{ .name = "ready", .value = no } },
        .{ .variable = .{ .name = "executing", .value = no } },
        .{ .comptime_scope = try builder.statements(&.{try builder.branch(try common.capabilities(builder), &.{.{ .expression = try builder.builtin(.compileError, &.{try builder.string("freestanding WASM does not provide I/O or process capabilities; use wasm32-wasi for a command application")}) }}, &.{})}) },
    });
}
