const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const Service = @import("root.zig").Service;

pub fn lower(builder: Builder, service: Service, index: usize) std.mem.Allocator.Error!node.Declaration {
    const allocator = builder.allocator;
    const module = try builder.identifier(try std.fmt.allocPrint(allocator, "service_{d}", .{index}));
    const input_type = try builder.field(module, "Input");
    const output_type = try builder.field(module, "Output");
    const void_type = try builder.expression(.{ .primitive = .void });
    const arena = try builder.path(&.{ "scope", "arena" });
    const input = try builder.identifier("input");
    const alloc = try builder.identifier("allocator");
    const body = try builder.identifier("body");
    const err = try builder.identifier("err");
    const empty = try builder.object(&.{});
    const oom = try builder.binary(.equal, err, try builder.expression(.{ .error_value = "OutOfMemory" }));
    var statements: std.ArrayList(node.Statement) = .empty;

    if (!service.requires_io) try statements.append(allocator, .{ .discard = try builder.identifier("io") });
    if (!service.requires_process) try statements.append(allocator, .{ .discard = try builder.identifier("process") });

    try statements.appendSlice(allocator, &.{
        .{ .constant = .{ .name = "allocator", .value = try builder.call(try builder.field(arena, "allocator"), &.{}) } },
        .{ .constant = .{ .name = "body", .value = try builder.binary(.coalesce, try builder.expression(.{ .try_value = try builder.call(try builder.identifier("readBody"), &.{ alloc, try builder.identifier("request") }) }), try builder.expression(.{ .return_value = null })) } },
    });

    const empty_input = try builder.expression(.{ .block = .{ .label = "input", .statements = try builder.statements(&.{
        try builder.branch(try builder.binary(.not_equal, try builder.field(body, "len"), try builder.integer(0)), &.{.{ .result = try response(builder, "bad_request", try builder.string("expected empty body"), &.{}) }}, &.{}),
        .{ .break_value = .{ .label = "input", .value = try builder.expression(.unit) } },
    }) } });

    const parsed = try builder.call(try builder.path(&.{ "std", "json", "parseFromSliceLeaky" }), &.{ input_type, alloc, body, try builder.object(&.{.{ .name = "allocate", .value = try builder.expression(.{ .enum_literal = "alloc_always" }) }}) });

    const parsed_input = try builder.expression(.{ .catch_scope = .{ .value = parsed, .capture = "err", .body = try builder.statements(&.{
        try builder.branch(oom, &.{.{ .result = err }}, &.{}),
        .{ .result = try response(builder, "bad_request", try builder.string("invalid JSON input"), &.{}) },
    }) } });

    try statements.append(allocator, .{ .constant = .{ .name = "input", .type_expr = input_type, .value = try builder.expression(.{ .conditional = .{ .condition = try builder.binary(.equal, input_type, void_type), .yes = empty_input, .no = parsed_input } }) } });

    var arguments: std.ArrayList(*const node.Expression) = .empty;

    try arguments.appendSlice(allocator, &.{ try builder.expression(.{ .address_of = arena }), input });

    if (service.slots.len != 0) {
        const context = try builder.identifier(try std.fmt.allocPrint(allocator, "Context_{d}", .{index}));

        try statements.append(allocator, .{ .variable = .{ .name = "context", .value = try builder.call(try builder.field(context, "init"), &.{try builder.identifier("scope")}) } });
        try arguments.append(allocator, try builder.expression(.{ .address_of = try builder.identifier("context") }));
    }

    if (service.requires_io) try arguments.append(allocator, try builder.identifier("io"));
    if (service.requires_process) try arguments.append(allocator, try builder.identifier("process"));

    const execute = try builder.call(try builder.field(module, "execute"), arguments.items);
    const canceled = try builder.binary(.equal, err, try builder.expression(.{ .error_value = "Canceled" }));

    const result = try builder.expression(.{ .catch_scope = .{ .value = execute, .capture = "err", .body = try builder.statements(&.{
        try builder.branch(try builder.binary(.logical_or, oom, canceled), &.{.{ .result = err }}, &.{}),
        .{ .expression = try builder.call(try builder.path(&.{ "std", "log", "err" }), &.{ try builder.string("Gateway service failed: {s}"), try builder.tuple(&.{try builder.builtin(.errorName, &.{err})}) }) },
        .{ .result = try response(builder, "internal_server_error", try builder.string("service failed"), &.{}) },
    }) } });

    const encoded = try builder.expression(.{ .conditional = .{
        .condition = try builder.binary(.equal, output_type, void_type),
        .yes = try builder.string("null"),
        .no = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "std", "json", "Stringify", "valueAlloc" }), &.{ alloc, try builder.identifier("output"), empty }) }),
    } });

    try statements.appendSlice(allocator, &.{
        .{ .constant = .{ .name = "output", .value = result } },
        .{ .scope = try @import("../host/json_output.zig").lowerFailure(builder, service.output, &.{
            .{ .expression = try builder.call(try builder.path(&.{ "std", "log", "err" }), &.{ try builder.string("Gateway service failed: {s}"), try builder.tuple(&.{try builder.string("NonFiniteJsonNumber")}) }) },
            .{ .result = try response(builder, "internal_server_error", try builder.string("service failed"), &.{}) },
        }) },
        .{ .constant = .{ .name = "encoded", .value = encoded } },
        .{ .result = try response(builder, "ok", try builder.identifier("encoded"), &.{try builder.object(&.{
            .{ .name = "name", .value = try builder.string("content-type") },
            .{ .name = "value", .value = try builder.string("application/json") },
        })}) },
    });

    return .{ .function = .{
        .name = try std.fmt.allocPrint(allocator, "invoke_{d}", .{index}),
        .parameters = try parameters(builder),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = void_type } }),
        .body = try statements.toOwnedSlice(allocator),
    } };
}

pub fn parameters(builder: Builder) std.mem.Allocator.Error![]const node.Field {
    return builder.allocator.dupe(node.Field, &.{
        .{ .name = "scope", .value = try builder.expression(.{ .pointer = try builder.path(&.{ "State", "Request" }) }) },
        .{ .name = "io", .value = try builder.path(&.{ "std", "Io" }) },
        .{ .name = "process", .value = try builder.path(&.{ "std", "process", "Init", "Minimal" }) },
        .{ .name = "request", .value = try builder.expression(.{ .pointer = try builder.path(&.{ "std", "http", "Server", "Request" }) }) },
    });
}

pub fn response(builder: Builder, status: []const u8, body: *const node.Expression, headers: []const *const node.Expression) std.mem.Allocator.Error!*const node.Expression {
    return builder.call(try builder.identifier("respond"), &.{
        try builder.identifier("request"),
        try builder.expression(.{ .enum_literal = status }),
        body,
        try builder.expression(.{ .address_of = try builder.tuple(headers) }),
    });
}
