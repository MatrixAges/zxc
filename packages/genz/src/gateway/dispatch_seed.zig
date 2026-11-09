const std = @import("std");
const model = @import("root.zig");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const invoke = @import("invoke_seed.zig");

pub fn lower(builder: Builder, routes: []const model.Route) std.mem.Allocator.Error!node.Declaration {
    var body: std.ArrayList(node.Statement) = .empty;
    const allocator = builder.allocator;
    const target = try builder.identifier("target");
    const valid = try builder.call(try builder.identifier("validHead"), &.{try builder.path(&.{ "request", "head_buffer" })});

    try body.append(allocator, try builder.branch(try builder.expression(.{ .unary = .{ .operator = .not, .operand = valid } }), &.{.{ .result = try invoke.response(builder, "bad_request", try builder.string("invalid request headers"), &.{}) }}, &.{}));

    if (routes.len == 0) {
        for ([_][]const u8{ "scope", "io", "process" }) |name| try body.append(allocator, .{ .discard = try builder.identifier(name) });
    } else {
        const query = try builder.call(try builder.path(&.{ "std", "mem", "indexOfScalar" }), &.{ try builder.expression(.{ .primitive = .u8 }), target, try builder.integer('?') });

        try body.appendSlice(allocator, &.{
            .{ .constant = .{ .name = "target", .value = try builder.path(&.{ "request", "head", "target" }) } },
            .{ .constant = .{ .name = "path", .value = try builder.expression(.{ .slice = .{ .target = target, .start = try builder.integer(0), .end = try builder.binary(.coalesce, query, try builder.field(target, "len")) } }) } },
        });
    }

    for (routes, 0..) |route, index| {
        const first = for (routes[0..index]) |previous| {
            if (std.mem.eql(u8, previous.path, route.path)) break false;
        } else true;

        if (!first) continue;

        var matching: std.ArrayList(node.Statement) = .empty;

        if (route.method == null) {
            try matching.append(allocator, .{ .result = try callService(builder, route.service) });
        } else {
            var methods: std.ArrayList([]const u8) = .empty;

            for (routes) |candidate| {
                if (!std.mem.eql(u8, candidate.path, route.path)) continue;

                const condition = try builder.binary(.equal, try builder.path(&.{ "request", "head", "method" }), try builder.expression(.{ .enum_literal = candidate.method.? }));

                try matching.append(allocator, try builder.branch(condition, &.{.{ .result = try callService(builder, candidate.service) }}, &.{}));
                try methods.append(allocator, candidate.method.?);
            }

            const header = try builder.object(&.{
                .{ .name = "name", .value = try builder.string("allow") },
                .{ .name = "value", .value = try builder.string(try std.mem.join(allocator, ", ", methods.items)) },
            });

            try matching.append(allocator, .{ .result = try invoke.response(builder, "method_not_allowed", try builder.string("method not allowed"), &.{header}) });
        }

        const matches = try builder.call(try builder.path(&.{ "std", "mem", "eql" }), &.{ try builder.expression(.{ .primitive = .u8 }), try builder.identifier("path"), try builder.string(route.path) });

        try body.append(allocator, try builder.branch(matches, matching.items, &.{}));
    }

    try body.append(allocator, .{ .result = try invoke.response(builder, "not_found", try builder.string("not found"), &.{}) });

    return .{ .function = .{
        .name = "dispatch",
        .parameters = try invoke.parameters(builder),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .void }) } }),
        .body = try builder.statements(body.items),
        .exported = true,
    } };
}

fn callService(builder: Builder, index: usize) std.mem.Allocator.Error!node.ExpressionId {
    return builder.call(try builder.identifier(try std.fmt.allocPrint(builder.allocator, "invoke_{d}", .{index})), &.{
        try builder.identifier("scope"),
        try builder.identifier("io"),
        try builder.identifier("process"),
        try builder.identifier("request"),
    });
}
