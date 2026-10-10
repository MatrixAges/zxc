const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Self = @This();
pub const Group = @import("capacity/group.zig");

buffer: *const node.Expression,
started: *const node.Expression,
reserve: ?*const node.Expression = null,
pub fn prepare(self: Self, lowering: *Lower, body: *std.ArrayList(node.Statement), source: *const node.Expression) Lower.Error!void {
    var first: std.ArrayList(node.Statement) = .empty;

    if (self.reserve) |limit| try first.append(lowering.allocator, .{ .expression = try self.method(lowering, "ensureTotalCapacityPrecise", &.{limit}, true) });

    try first.appendSlice(lowering.allocator, &.{
        .{ .expression = try self.method(lowering, "appendSlice", &.{source}, true) },
        .{ .assignment = .{ .target = self.started, .value = try lowering.builder.expression(.{ .boolean = true }) } },
    });

    try body.append(lowering.allocator, .{ .branch = .{
        .condition = try lowering.builder.expression(.{ .unary = .{ .operator = .not, .operand = self.started } }),
        .yes = try first.toOwnedSlice(lowering.allocator),
        .no = try lowering.allocator.dupe(node.Statement, &.{try self.resize(lowering, source)}),
    } });
}

pub fn items(self: Self, lowering: *Lower) Lower.Error!*const node.Expression {
    return lowering.field(self.buffer, "items");
}

fn resize(self: Self, lowering: *Lower, source: *const node.Expression) Lower.Error!node.Statement {
    return .{ .assignment = .{ .target = try lowering.field(try self.items(lowering), "len"), .value = try lowering.field(source, "len") } };
}

pub fn method(self: Self, lowering: *Lower, name: []const u8, arguments: []const *const node.Expression, fallible: bool) Lower.Error!*const node.Expression {
    const values = try lowering.allocator.alloc(*const node.Expression, arguments.len + 1);
    values[0] = try lowering.builder.identifier("allocator");

    @memcpy(values[1..], arguments);

    return lowering.call(try lowering.field(self.buffer, name), values, fallible);
}

/// Column buffer stored in a shared group, released by the group's single cleanup.
pub fn member(lowering: *Lower, group: *Group, element: *const node.Expression) Lower.Error!Self {
    const index = group.members.items.len;
    const buffer_name = try std.fmt.allocPrint(lowering.allocator, "buffer_{d}", .{index});
    const started_name = try std.fmt.allocPrint(lowering.allocator, "started_{d}", .{index});
    const release = try lowering.call(try lowering.field(try Group.own(lowering, buffer_name), "deinit"), &.{try lowering.builder.identifier("zx_allocator")}, false);

    try group.add(lowering, .{ .name = buffer_name, .type_expr = try lowering.call(try lowering.field(try lowering.builder.identifier("std"), "ArrayList"), &.{element}, false), .initial = try lowering.builder.expression(.{ .enum_literal = "empty" }), .release = release });
    try group.add(lowering, .{ .name = started_name, .type_expr = try lowering.builder.expression(.{ .primitive = .bool }), .initial = try lowering.builder.expression(.{ .boolean = false }) });

    return .{ .buffer = try group.field(lowering, buffer_name), .started = try group.field(lowering, started_name) };
}

/// The owned slice lives in a shared group freed by one errdefer.
pub fn take(self: Self, lowering: *Lower, body: *std.ArrayList(node.Statement), group: *Group, source: *const node.Expression, element: *const node.Expression) Lower.Error!*const node.Expression {
    const name = try std.fmt.allocPrint(lowering.allocator, "owned_{d}", .{group.members.items.len});
    const release = try lowering.call(try lowering.field(try lowering.builder.identifier("zx_allocator"), "free"), &.{try Group.own(lowering, name)}, false);

    try group.add(lowering, .{
        .name = name,
        .type_expr = try lowering.builder.expression(.{ .const_slice = element }),
        .initial = try lowering.builder.expression(.{ .address_of = try lowering.builder.expression(.{ .array = .{ .element_type = element, .values = &.{} } }) }),
        .release = release,
    });

    const owned = try group.field(lowering, name);

    try body.append(lowering.allocator, .{ .branch = .{
        .condition = self.started,
        .yes = try lowering.allocator.dupe(node.Statement, &.{
            try self.resize(lowering, source),
            .{ .assignment = .{ .target = owned, .value = try self.method(lowering, "toOwnedSlice", &.{}, true) } },
        }),
        .no = &.{},
    } });

    return owned;
}

pub fn finish(self: Self, lowering: *Lower, body: *std.ArrayList(node.Statement), group: *Group, target: *const node.Expression, element: *const node.Expression) Lower.Error!void {
    const owned = try self.take(lowering, body, group, target, element);

    try body.append(lowering.allocator, .{ .branch = .{
        .condition = self.started,
        .yes = try lowering.allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = target, .value = owned } }}),
        .no = &.{},
    } });
}
