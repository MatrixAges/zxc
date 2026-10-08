const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const Self = @This();

buffer: *const node.Expression,
started: *const node.Expression,
reserve: ?*const node.Expression = null,
pub fn create(lowering: *Lower, body: *std.ArrayList(node.Statement), element: *const node.Expression) Lower.Error!Self {
    const name = try lowering.fresh("state_capacity");
    const started_name = try lowering.fresh("state_capacity_started");
    const storage = Self{ .buffer = try lowering.builder.identifier(name), .started = try lowering.builder.identifier(started_name) };
    const buffer_type = try lowering.call(try lowering.field(try lowering.builder.identifier("std"), "ArrayList"), &.{element}, false);

    try body.append(lowering.allocator, .{ .variable = .{ .name = name, .type_expr = buffer_type, .value = try lowering.builder.expression(.{ .enum_literal = "empty" }) } });
    try body.append(lowering.allocator, .{ .variable = .{ .name = started_name, .value = try lowering.builder.expression(.{ .boolean = false }) } });
    try body.append(lowering.allocator, .{ .defer_expression = try storage.method(lowering, "deinit", &.{}, false) });

    return storage;
}

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

pub fn finish(self: Self, lowering: *Lower, body: *std.ArrayList(node.Statement), target: *const node.Expression, element: *const node.Expression) Lower.Error!void {
    const owned = try self.take(lowering, body, target, element);

    try body.append(lowering.allocator, .{ .branch = .{
        .condition = self.started,
        .yes = try lowering.allocator.dupe(node.Statement, &.{.{ .assignment = .{ .target = target, .value = owned } }}),
        .no = &.{},
    } });
}

pub fn take(self: Self, lowering: *Lower, body: *std.ArrayList(node.Statement), source: *const node.Expression, element: *const node.Expression) Lower.Error!*const node.Expression {
    const name = try lowering.fresh("state_owned");
    const owned = try lowering.builder.identifier(name);
    const empty = try lowering.builder.expression(.{ .array = .{ .element_type = element, .values = &.{} } });

    try body.append(lowering.allocator, .{ .variable = .{
        .name = name,
        .type_expr = try lowering.builder.expression(.{ .const_slice = element }),
        .value = try lowering.builder.expression(.{ .address_of = empty }),
    } });

    try body.append(lowering.allocator, .{ .errdefer_expression = try lowering.call(try lowering.field(try lowering.builder.identifier("allocator"), "free"), &.{owned}, false) });

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

pub fn method(self: Self, lowering: *Lower, name: []const u8, arguments: []const *const node.Expression, fallible: bool) Lower.Error!*const node.Expression {
    const values = try lowering.allocator.alloc(*const node.Expression, arguments.len + 1);
    values[0] = try lowering.builder.identifier("allocator");

    @memcpy(values[1..], arguments);

    return lowering.call(try lowering.field(self.buffer, name), values, fallible);
}
