const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");
const state = @import("../state.zig");
const storage = @import("storage.zig");

pub fn lower(builder: Builder, declarations: *std.ArrayList(node.Declaration), objects: []const state.Object, requirements: state.Requirements, execute: bool) std.mem.Allocator.Error!void {
    const allocator = builder.allocator;
    const writable = storage.writable(objects);
    const self = try builder.identifier("self");
    const arena_type = try builder.path(&.{ "std", "heap", "ArenaAllocator" });
    const self_pointer = try builder.expression(.{ .pointer = try builder.identifier("Self") });
    const request_parameters = try allocator.dupe(node.Field, &.{.{ .name = "self", .value = try builder.expression(.{ .pointer = try builder.identifier("Request") }) }});
    var initial: std.ArrayList(node.Field) = .empty;
    var fields: std.ArrayList(node.Field) = .empty;
    var methods: std.ArrayList(node.Declaration) = .empty;

    try @import("region.zig").lower(builder, declarations, writable);
    try declarations.append(allocator, try @import("reclaim.zig").lower(builder, objects, storage.reclaimable(objects)));

    try initial.appendSlice(allocator, &.{
        .{ .name = "parent", .value = self },
        .{ .name = "arena", .value = try builder.call(try builder.field(arena_type, "init"), &.{try builder.path(&.{ "self", "arena", "child_allocator" })}) },
    });

    try fields.appendSlice(allocator, &.{
        .{ .name = "parent", .value = self_pointer },
        .{ .name = "arena", .value = arena_type },
    });

    if (writable) try fields.append(allocator, .{ .name = "retained", .value = try builder.expression(.{ .optional_type = try builder.expression(.{ .pointer = try builder.identifier("Region") }) }), .default_value = try builder.expression(.null_value) });

    for (0..objects.len) |index| {
        const name = try std.fmt.allocPrint(allocator, "store_{d}", .{index});
        const module = try builder.identifier(try std.fmt.allocPrint(allocator, "initial_{d}", .{index}));

        try initial.append(allocator, .{ .name = name, .value = try builder.field(self, name) });
        try fields.append(allocator, .{ .name = name, .value = try builder.expression(.{ .pointer = try builder.field(module, "Output") }) });
    }

    try declarations.append(allocator, .{ .function = .{
        .name = "request",
        .parameters = try allocator.dupe(node.Field, &.{.{ .name = "self", .value = self_pointer }}),
        .return_type = try builder.identifier("Request"),
        .body = try allocator.dupe(node.Statement, &.{.{ .result = try builder.expression(.{ .object = .{ .fields = try initial.toOwnedSlice(allocator) } }) }}),
        .exported = true,
    } });

    if (execute) {
        var parameters: std.ArrayList(node.Field) = .empty;
        var arguments: std.ArrayList(*const node.Expression) = .empty;

        try parameters.appendSlice(allocator, request_parameters);
        try parameters.append(allocator, .{ .name = "input", .value = try builder.path(&.{ "application", "Input" }) });
        try arguments.appendSlice(allocator, &.{ try builder.expression(.{ .address_of = try builder.field(self, "arena") }), try builder.identifier("input"), self });

        if (requirements.io) {
            try parameters.append(allocator, .{ .name = "io", .value = try builder.path(&.{ "std", "Io" }) });
            try arguments.append(allocator, try builder.identifier("io"));
        }

        if (requirements.process) {
            try parameters.append(allocator, .{ .name = "process", .value = try builder.path(&.{ "std", "process", "Init", "Minimal" }) });
            try arguments.append(allocator, try builder.identifier("process"));
        }

        try methods.append(allocator, .{ .function = .{
            .name = "execute",
            .parameters = try parameters.toOwnedSlice(allocator),
            .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.path(&.{ "application", "Output" }) } }),
            .body = try allocator.dupe(node.Statement, &.{.{ .result = try builder.call(try builder.path(&.{ "application", "execute" }), arguments.items) }}),
            .exported = true,
        } });
    }

    const release = node.Statement{ .expression = try builder.call(try builder.path(&.{ "self", "arena", "deinit" }), &.{}) };

    const cleanup = if (writable) node.Statement{ .branch = .{
        .condition = try builder.field(self, "retained"),
        .capture = "region",
        .yes = try allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = try builder.path(&.{ "region", "arena" }), .value = try builder.field(self, "arena") } }}),
        .no = try allocator.dupe(node.Statement, &.{release}),
    } } else release;

    try methods.append(allocator, .{ .function = .{
        .name = "deinit",
        .parameters = request_parameters,
        .return_type = try builder.expression(.{ .primitive = .void }),
        .body = try allocator.dupe(node.Statement, &.{ cleanup, .{ .assignment = .{ .target = try builder.expression(.{ .dereference = self }), .value = try builder.expression(.undefined_value) } } }),
        .exported = true,
    } });

    try methods.append(allocator, try @import("request_commit.zig").lower(builder, objects));

    try declarations.append(allocator, .{ .constant = .{
        .name = "Request",
        .value = try builder.expression(.{ .container_type = .{ .fields = try fields.toOwnedSlice(allocator), .declarations = try methods.toOwnedSlice(allocator) } }),
        .exported = true,
    } });
}
