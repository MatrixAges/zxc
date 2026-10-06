const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const common = @import("common.zig");

pub fn render(allocator: std.mem.Allocator, stateful: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    var declarations: std.ArrayList(node.Declaration) = .empty;

    for ([_][]const u8{ "std", "application", "zxc_napi", "context.zig", "task.zig" }, [_][]const u8{ "std", "application", "napi", "Context", "Task" }) |module, name| {
        try declarations.append(builder.allocator, .{ .constant = .{ .name = name, .value = try builder.builtin(.import, &.{try builder.string(module)}) } });
    }

    try declarations.appendSlice(builder.allocator, &.{
        .{ .constant = .{ .name = "api", .value = try builder.path(&.{ "napi", "api" }) } },
        try common.callback(builder, "callback", "enqueue", true),
        try lower(builder, stateful),
    });

    return @import("../../render.zig").render(allocator, declarations.items);
}

fn lower(builder: Builder, stateful: bool) std.mem.Allocator.Error!node.Declaration {
    const env = try builder.identifier("env");
    const arguments = try builder.identifier("arguments");
    const count = try builder.identifier("count");
    const input_count = try builder.identifier("input_count");
    const task = try builder.identifier("task");
    const busy = try builder.path(&.{ "context", "busy" });
    const nil = try builder.expression(.null_value);
    const api_value = try builder.path(&.{ "api", "Value" });
    var body: std.ArrayList(node.Statement) = .empty;

    try body.appendSlice(builder.allocator, &.{
        .{ .variable = .{ .name = "arguments", .type_expr = try builder.expression(.{ .fixed_array_type = .{ .length = try builder.integer(4), .element = api_value } }), .value = try builder.expression(.undefined_value) } },
        .{ .variable = .{ .name = "count", .type_expr = try builder.expression(.{ .primitive = .usize }), .value = try builder.field(arguments, "len") } },
        .{ .variable = .{ .name = "data", .type_expr = try common.dataType(builder), .value = nil } },
        try common.check(builder, "napi_get_cb_info", &.{ env, try builder.identifier("info"), try builder.expression(.{ .address_of = count }), try builder.expression(.{ .address_of = arguments }), nil, try builder.expression(.{ .address_of = try builder.identifier("data") }) }),
        .{ .constant = .{ .name = "input_count", .type_expr = try builder.expression(.{ .primitive = .usize }), .value = try builder.expression(.{ .conditional = .{
            .condition = try builder.binary(.equal, try builder.path(&.{ "application", "Input" }), try builder.expression(.{ .primitive = .void })),
            .yes = try builder.integer(0),
            .no = try builder.integer(1),
        } }) } },
        try builder.branch(try builder.binary(.not_equal, count, try builder.binary(.add, input_count, try builder.integer(2))), &.{.{ .result = try builder.expression(.{ .error_value = "InvalidArgumentCount" }) }}, &.{}),
        try common.context(builder),
        try builder.branch(try builder.path(&.{ "context", "closing" }), &.{.{ .result = try builder.expression(.{ .error_value = "EnvironmentClosing" }) }}, &.{}),
        try builder.branch(busy, &.{.{ .result = try builder.expression(.{ .error_value = "ReentrantInvocation" }) }}, &.{}),
        .{ .assignment = .{ .target = busy, .value = try builder.expression(.{ .boolean = true }) } },
        .{ .defer_scope = try builder.statements(&.{.{ .assignment = .{ .target = busy, .value = try builder.expression(.{ .boolean = false }) } }}) },
        .{ .for_loop = .{
            .iterable = try builder.expression(.{ .slice = .{ .target = arguments, .start = input_count, .end = count } }),
            .capture = "callback_value",
            .body = try builder.statements(&.{
                .{ .variable = .{ .name = "kind", .type_expr = try builder.path(&.{ "api", "Kind" }), .value = try builder.expression(.undefined_value) } },
                try common.check(builder, "napi_typeof", &.{ env, try builder.identifier("callback_value"), try builder.expression(.{ .address_of = try builder.identifier("kind") }) }),
                try builder.branch(try builder.binary(.not_equal, try builder.identifier("kind"), try builder.expression(.{ .enum_literal = "function" })), &.{.{ .result = try builder.expression(.{ .error_value = "ExpectedFunction" }) }}, &.{}),
            }),
        } },
        .{ .variable = .{ .name = "undefined_value", .type_expr = api_value, .value = nil } },
        try common.check(builder, "napi_get_undefined", &.{ env, try builder.expression(.{ .address_of = try builder.identifier("undefined_value") }) }),
        .{ .constant = .{ .name = "task", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "std", "heap", "page_allocator", "create" }), &.{try builder.identifier("Task")}) }) } },
        .{ .assignment = .{ .target = try builder.expression(.{ .dereference = task }), .value = try builder.object(&.{
            .{ .name = "context", .value = try builder.identifier("context") },
            .{ .name = "arena", .value = try builder.call(try builder.path(&.{ "std", "heap", "ArenaAllocator", "init" }), &.{try builder.path(&.{ "std", "heap", "page_allocator" })}) },
        }) } },
        .{ .expression = try builder.call(try builder.path(&.{ "context", "retain" }), &.{}) },
        .{ .errdefer_expression = try builder.call(try builder.field(task, "destroy"), &.{}) },
        .{ .assignment = .{ .target = try builder.field(task, "input"), .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "napi", "read" }), &.{
            try builder.call(try builder.path(&.{ "task", "arena", "allocator" }), &.{}),                                                                                                                                                                     env,
            try builder.expression(.{ .conditional = .{ .condition = try builder.binary(.equal, input_count, try builder.integer(0)), .yes = nil, .no = try builder.expression(.{ .index = .{ .target = arguments, .index = try builder.integer(0) } }) } }),
        }) }) } },
    });

    for ([_][]const u8{ "resolve", "reject" }, 0..) |name, offset| {
        try body.append(builder.allocator, try common.check(builder, "napi_create_reference", &.{ env, try builder.expression(.{ .index = .{ .target = arguments, .index = try builder.binary(.add, input_count, try builder.integer(offset)) } }), try builder.integer(1), try builder.expression(.{ .address_of = try builder.field(task, name) }) }));
    }

    try body.appendSlice(builder.allocator, &.{
        .{ .variable = .{ .name = "name", .type_expr = api_value, .value = nil } },
        try common.check(builder, "napi_create_string_utf8", &.{ env, try builder.string("zxc.execute"), try builder.integer(11), try builder.expression(.{ .address_of = try builder.identifier("name") }) }),
        try common.check(builder, "napi_create_async_work", &.{ env, nil, try builder.identifier("name"), try builder.path(&.{ "Task", "execute" }), try builder.path(&.{ "Task", "complete" }), task, try builder.expression(.{ .address_of = try builder.field(task, "work") }) }),
    });

    const start = node.Statement{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.field(task, "start"), &.{}) }) };

    if (stateful) {
        try body.append(builder.allocator, try builder.branch(try builder.path(&.{ "context", "running" }), &.{
            .{ .branch = .{ .condition = try builder.path(&.{ "context", "tail" }), .capture = "tail", .yes = try builder.statements(&.{.{ .assignment = .{ .target = try builder.path(&.{ "tail", "next" }), .value = task } }}), .no = try builder.statements(&.{.{ .assignment = .{ .target = try builder.path(&.{ "context", "head" }), .value = task } }}) } },
            .{ .assignment = .{ .target = try builder.path(&.{ "context", "tail" }), .value = task } },
        }, &.{ start, .{ .assignment = .{ .target = try builder.path(&.{ "context", "running" }), .value = try builder.expression(.{ .boolean = true }) } } }));
    } else try body.append(builder.allocator, start);

    try body.append(builder.allocator, .{ .result = try builder.identifier("undefined_value") });

    return .{ .function = .{ .name = "enqueue", .parameters = try common.parameters(builder), .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = api_value } }), .body = try body.toOwnedSlice(builder.allocator) } };
}
