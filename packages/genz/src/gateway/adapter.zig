const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");
const Service = @import("root.zig").Service;

pub fn lower(builder: Builder, service: Service, index: usize) std.mem.Allocator.Error!?node.Declaration {
    if (service.slots.len == 0) return null;

    const allocator = builder.allocator;
    const request_type = try builder.field(try builder.identifier("State"), "Request");
    const request_pointer = try builder.expression(.{ .pointer = request_type });
    const this = try builder.builtin(.This, &.{});
    const request = try builder.identifier("request");
    const changes = try builder.identifier("changes");
    var fields: std.ArrayList(node.Field) = .empty;
    var initial: std.ArrayList(node.Field) = .empty;
    var pending: std.ArrayList(node.Field) = .empty;
    var body: std.ArrayList(node.Statement) = .empty;

    try fields.append(allocator, .{ .name = "request", .value = request_pointer });
    try initial.append(allocator, .{ .name = "request", .value = request });

    for (service.slots, 0..) |slot, local| {
        const name = try std.fmt.allocPrint(allocator, "store_{d}", .{local});
        const target = try std.fmt.allocPrint(allocator, "store_{d}", .{slot.index});
        const change = try builder.field(changes, name);

        try fields.append(allocator, .{ .name = name, .value = try builder.builtin(.FieldType, &.{ request_type, try builder.string(target) }) });
        try initial.append(allocator, .{ .name = name, .value = try builder.field(request, target) });
        try pending.append(allocator, .{ .name = target, .value = change });

        if (!slot.writable) {
            const failure = try allocator.dupe(node.Statement, &.{.{ .result = try builder.expression(.{ .error_value = "StoreNotWritable" }) }});
            const condition = try builder.expression(.{ .binary = .{ .operator = .not_equal, .left = change, .right = try builder.expression(.null_value) } });

            try body.append(allocator, .{ .branch = .{ .condition = condition, .yes = failure, .no = &.{} } });
        }
    }

    const context_request = try builder.field(try builder.identifier("self"), "request");
    const commit = try builder.call(try builder.field(context_request, "commit"), &.{try builder.expression(.{ .object = .{ .fields = try pending.toOwnedSlice(allocator) } })});

    try body.append(allocator, .{ .expression = try builder.expression(.{ .try_value = commit }) });

    const declarations = try allocator.dupe(node.Declaration, &.{
        .{ .function = .{
            .name = "init",
            .parameters = try allocator.dupe(node.Field, &.{.{ .name = "request", .value = request_pointer }}),
            .return_type = this,
            .body = try allocator.dupe(node.Statement, &.{.{ .result = try builder.expression(.{ .object = .{ .fields = try initial.toOwnedSlice(allocator) } }) }}),
        } },
        .{ .function = .{
            .name = "commit",
            .parameters = try allocator.dupe(node.Field, &.{
                .{ .name = "self", .value = try builder.expression(.{ .pointer = this }) },
                .{ .name = "changes", .value = try builder.field(try builder.identifier(try std.fmt.allocPrint(allocator, "service_{d}", .{index})), "zx_pending") },
            }),
            .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .void }) } }),
            .body = try body.toOwnedSlice(allocator),
            .exported = true,
        } },
    });

    return .{ .constant = .{
        .name = try std.fmt.allocPrint(allocator, "Context_{d}", .{index}),
        .value = try builder.expression(.{ .container_type = .{ .fields = try fields.toOwnedSlice(allocator), .declarations = declarations } }),
    } };
}
