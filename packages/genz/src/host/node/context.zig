const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn render(allocator: std.mem.Allocator, stateful: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    const memory = builder.allocator;
    const self = try builder.identifier("self");
    const references = try builder.field(self, "references");
    const head = try builder.field(self, "head");
    const void_type = try builder.expression(.{ .primitive = .void });
    const no = try builder.expression(.{ .boolean = false });
    const nil = try builder.expression(.null_value);
    const task_pointer = try builder.expression(.{ .optional_type = try builder.expression(.{ .pointer = try builder.identifier("Task") }) });
    const parameters = try memory.dupe(node.Field, &.{.{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.identifier("Self") }) }});
    var release: std.ArrayList(node.Statement) = .empty;

    try release.appendSlice(memory, &.{
        .{ .assignment = .{ .target = references, .value = try builder.binary(.subtract, references, try builder.integer(1)) } },
        try builder.branch(try builder.binary(.not_equal, references, try builder.integer(0)), &.{.{ .result = null }}, &.{}),
        try builder.branch(try builder.field(self, "hooked"), &.{.{ .discard = try builder.call(try builder.path(&.{ "api", "napi_remove_env_cleanup_hook" }), &.{ try builder.field(self, "env"), try builder.identifier("cleanup"), self }) }}, &.{}),
    });

    if (stateful) try release.append(memory, .{ .expression = try builder.call(try builder.path(&.{ "self", "state", "deinit" }), &.{}) });

    try release.appendSlice(memory, &.{
        .{ .expression = try builder.call(try builder.path(&.{ "self", "arena", "deinit" }), &.{}) },
        .{ .expression = try builder.call(try builder.path(&.{ "std", "heap", "page_allocator", "destroy" }), &.{self}) },
    });

    return @import("../../render.zig").render(allocator, &.{
        .{ .constant = .{ .name = "std", .value = try builder.builtin(.import, &.{try builder.string("std")}) } },
        .{ .constant = .{ .name = "api", .value = try builder.field(try builder.builtin(.import, &.{try builder.string("zxc_napi")}), "api") } },
        .{ .constant = .{ .name = "State", .value = if (stateful) try builder.builtin(.import, &.{try builder.string("zxc_state")}) else void_type } },
        .{ .constant = .{ .name = "Task", .value = try builder.builtin(.import, &.{try builder.string("task.zig")}) } },
        .{ .constant = .{ .name = "Self", .value = try builder.builtin(.This, &.{}) } },
        .{ .field = .{ .name = "arena", .value = try builder.path(&.{ "std", "heap", "ArenaAllocator" }) } },
        .{ .field = .{ .name = "state", .value = try builder.identifier("State"), .default_value = try builder.expression(.undefined_value) } },
        .{ .field = .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) } },
        .{ .field = .{ .name = "references", .value = try builder.expression(.{ .primitive = .usize }), .default_value = try builder.integer(1) } },
        .{ .field = .{ .name = "hooked", .value = try builder.expression(.{ .primitive = .bool }), .default_value = no } },
        .{ .field = .{ .name = "busy", .value = try builder.expression(.{ .primitive = .bool }), .default_value = no } },
        .{ .field = .{ .name = "running", .value = try builder.expression(.{ .primitive = .bool }), .default_value = no } },
        .{ .field = .{ .name = "closing", .value = try builder.expression(.{ .primitive = .bool }), .default_value = no } },
        .{ .field = .{ .name = "head", .value = task_pointer, .default_value = nil } },
        .{ .field = .{ .name = "tail", .value = task_pointer, .default_value = nil } },
        .{ .function = .{
            .name = "retain",
            .parameters = parameters,
            .return_type = void_type,
            .exported = true,
            .body = try builder.statements(&.{.{ .assignment = .{ .target = references, .value = try builder.binary(.add, references, try builder.integer(1)) } }}),
        } },
        .{ .function = .{ .name = "release", .parameters = parameters, .return_type = void_type, .body = try release.toOwnedSlice(memory), .exported = true } },
        .{ .function = .{
            .name = "close",
            .parameters = parameters,
            .return_type = void_type,
            .exported = true,
            .body = try builder.statements(&.{
                .{ .assignment = .{ .target = try builder.field(self, "closing"), .value = try builder.expression(.{ .boolean = true }) } },
                .{ .while_loop = .{ .condition = head, .capture = "task", .body = try builder.statements(&.{
                    .{ .assignment = .{ .target = head, .value = try builder.path(&.{ "task", "next" }) } },
                    .{ .expression = try builder.call(try builder.path(&.{ "task", "destroy" }), &.{}) },
                }) } },
                .{ .assignment = .{ .target = try builder.field(self, "tail"), .value = nil } },
            }),
        } },
        .{ .function = .{
            .name = "cleanup",
            .parameters = try memory.dupe(node.Field, &.{.{ .name = "data", .value = try builder.expression(.{ .optional_type = try builder.expression(.{ .pointer = try builder.expression(.{ .primitive = .anyopaque }) }) }) }}),
            .return_type = void_type,
            .calling_convention = try builder.expression(.{ .enum_literal = "c" }),
            .exported = true,
            .body = try builder.statements(&.{
                .{ .constant = .{ .name = "self", .type_expr = try builder.expression(.{ .pointer = try builder.identifier("Self") }), .value = try builder.builtin(.ptrCast, &.{try builder.builtin(.alignCast, &.{try builder.expression(.{ .optional_unwrap = try builder.identifier("data") })})}) } },
                .{ .assignment = .{ .target = try builder.field(self, "hooked"), .value = no } },
                .{ .expression = try builder.call(try builder.field(self, "retain"), &.{}) },
                .{ .expression = try builder.call(try builder.field(self, "close"), &.{}) },
                .{ .expression = try builder.call(try builder.field(self, "release"), &.{}) },
            }),
        } },
    });
}
