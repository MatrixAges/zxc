const std = @import("std");
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");
const common = @import("../common.zig");
const complete = @import("complete.zig");

pub fn render(allocator: std.mem.Allocator, stateful: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    const memory = builder.allocator;
    const nil = try builder.expression(.null_value);
    const void_type = try builder.expression(.{ .primitive = .void });
    var declarations: std.ArrayList(node.Declaration) = .empty;

    for ([_][]const u8{ "std", "application", "zxc_napi", "context.zig" }, [_][]const u8{ "std", "application", "napi", "Context" }) |module, name| {
        try declarations.append(memory, .{ .constant = .{ .name = name, .value = try builder.builtin(.import, &.{try builder.string(module)}) } });
    }

    try declarations.appendSlice(memory, &.{
        .{ .constant = .{ .name = "api", .value = try builder.path(&.{ "napi", "api" }) } },
        .{ .constant = .{ .name = "Request", .value = if (stateful) try builder.field(try builder.builtin(.import, &.{try builder.string("zxc_state")}), "Request") else void_type } },
        .{ .constant = .{ .name = "Self", .value = try builder.builtin(.This, &.{}) } },
        .{ .field = .{ .name = "context", .value = try builder.expression(.{ .pointer = try builder.identifier("Context") }) } },
        .{ .field = .{ .name = "arena", .value = try builder.path(&.{ "std", "heap", "ArenaAllocator" }) } },
        .{ .field = .{ .name = "input", .value = try builder.path(&.{ "application", "Input" }), .default_value = try builder.expression(.undefined_value) } },
        .{ .field = .{ .name = "output", .value = try builder.expression(.{ .error_union = .{ .payload = try builder.path(&.{ "application", "Output" }) } }), .default_value = try builder.expression(.{ .error_value = "WorkNotExecuted" }) } },
        .{ .field = .{ .name = "request", .value = try builder.expression(.{ .optional_type = try builder.identifier("Request") }), .default_value = nil } },
    });

    for ([_][]const u8{ "work", "resolve", "reject" }, [_][]const u8{ "Work", "Ref", "Ref" }) |name, kind| {
        try declarations.append(memory, .{ .field = .{ .name = name, .value = try builder.path(&.{ "api", kind }), .default_value = nil } });
    }

    try declarations.appendSlice(memory, &.{
        .{ .field = .{ .name = "next", .value = try builder.expression(.{ .optional_type = try builder.expression(.{ .pointer = try builder.identifier("Self") }) }), .default_value = nil } },
        try destroy(builder, stateful),
        .{ .function = .{
            .name = "start",
            .exported = true,
            .parameters = try selfParameters(builder),
            .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = void_type } }),
            .body = try builder.statements(&.{try common.check(builder, "napi_queue_async_work", &.{ try builder.path(&.{ "self", "context", "env" }), try builder.path(&.{ "self", "work" }) })}),
        } },
        try execute(builder, stateful),
        try complete.lower(builder, stateful),
        try @import("settle.zig").lower(builder),
    });

    return @import("../../../render.zig").render(allocator, declarations.items);
}

fn selfParameters(builder: Builder) std.mem.Allocator.Error![]const node.Field {
    return builder.allocator.dupe(node.Field, &.{.{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.identifier("Self") }) }});
}

fn destroy(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    var body: std.ArrayList(node.Statement) = .empty;

    try body.appendSlice(builder.allocator, &.{
        .{ .constant = .{ .name = "context", .value = try builder.path(&.{ "self", "context" }) } },
        .{ .constant = .{ .name = "env", .value = try builder.path(&.{ "context", "env" }) } },
    });

    for ([_][]const u8{ "work", "resolve", "reject" }, [_][]const u8{ "napi_delete_async_work", "napi_delete_reference", "napi_delete_reference" }) |name, release| {
        const field = try builder.path(&.{ "self", name });

        try body.append(builder.allocator, try builder.branch(try builder.binary(.not_equal, field, try builder.expression(.null_value)), &.{.{ .discard = try builder.call(try builder.path(&.{ "api", release }), &.{ try builder.identifier("env"), field }) }}, &.{}));
    }

    if (stateful) try body.append(builder.allocator, .{ .branch = .{
        .condition = try builder.path(&.{ "self", "request" }),
        .capture = "request",
        .capture_reference = true,
        .yes = try builder.statements(&.{.{ .expression = try builder.call(try builder.path(&.{ "request", "deinit" }), &.{}) }}),
        .no = &.{},
    } });

    try body.appendSlice(builder.allocator, &.{
        .{ .expression = try builder.call(try builder.path(&.{ "self", "arena", "deinit" }), &.{}) },
        .{ .expression = try builder.call(try builder.path(&.{ "std", "heap", "page_allocator", "destroy" }), &.{try builder.identifier("self")}) },
        .{ .expression = try builder.call(try builder.path(&.{ "context", "release" }), &.{}) },
    });

    return .{ .function = .{ .name = "destroy", .exported = true, .parameters = try selfParameters(builder), .return_type = try builder.expression(.{ .primitive = .void }), .body = try body.toOwnedSlice(builder.allocator) } };
}

fn execute(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    var body: std.ArrayList(node.Statement) = .empty;

    try body.append(builder.allocator, try complete.selfBinding(builder));

    const arena = try builder.path(&.{ "self", "arena" });
    const input = try builder.path(&.{ "self", "input" });
    const request = try builder.expression(.{ .optional_unwrap = try builder.path(&.{ "self", "request" }) });

    if (stateful) try body.appendSlice(builder.allocator, &.{
        .{ .assignment = .{ .target = try builder.path(&.{ "self", "request" }), .value = try builder.call(try builder.path(&.{ "self", "context", "state", "request" }), &.{}) } },
        .{ .assignment = .{ .target = try builder.field(request, "arena"), .value = arena } },
        .{ .assignment = .{ .target = arena, .value = try builder.call(try builder.path(&.{ "std", "heap", "ArenaAllocator", "init" }), &.{try builder.path(&.{ "std", "heap", "page_allocator" })}) } },
    });

    try body.append(builder.allocator, .{ .assignment = .{
        .target = try builder.path(&.{ "self", "output" }),
        .value = if (stateful) try builder.call(try builder.field(request, "execute"), &.{input}) else try builder.call(try builder.path(&.{ "application", "execute" }), &.{ try builder.expression(.{ .address_of = arena }), input }),
    } });

    return .{ .function = .{
        .name = "execute",
        .exported = true,
        .calling_convention = try builder.expression(.{ .enum_literal = "c" }),
        .parameters = try builder.allocator.dupe(node.Field, &.{
            .{ .name = "_", .value = try builder.path(&.{ "api", "Env" }) },
            .{ .name = "data", .value = try common.dataType(builder) },
        }),
        .return_type = try builder.expression(.{ .primitive = .void }),
        .body = try body.toOwnedSlice(builder.allocator),
    } };
}
