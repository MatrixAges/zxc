const std = @import("std");
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const Self = @This();
/// Locals that share one cleanup: each member becomes a field of one struct variable whose release method
/// frees every member, so a single defer or errdefer runs per scope exit instead of one per member.
pub const Member = struct { name: []const u8, type_expr: *const node.Expression, initial: *const node.Expression, release: ?*const node.Expression = null };

name: []const u8,
position: usize,
members: std.ArrayList(Member) = .empty,
pub fn init(lowering: *Lower, body: *const std.ArrayList(node.Statement), prefix: []const u8) Lower.Error!Self {
    return .{ .name = try lowering.fresh(prefix), .position = body.items.len };
}

/// Field access on the shared variable for the next member.
pub fn field(self: *const Self, lowering: *Lower, name: []const u8) Lower.Error!*const node.Expression {
    return lowering.field(try lowering.builder.identifier(self.name), name);
}

pub fn add(self: *Self, lowering: *Lower, member: Member) Lower.Error!void {
    try self.members.append(lowering.allocator, member);
}

/// Inserts the shared declaration and its cleanup before the first statement that used a member.
pub fn seal(self: *const Self, lowering: *Lower, body: *std.ArrayList(node.Statement), cleanup: enum { always, on_error }) Lower.Error!void {
    if (self.members.items.len == 0) return;

    const fields = try lowering.allocator.alloc(node.Field, self.members.items.len);
    var releases: std.ArrayList(node.Statement) = .empty;

    for (self.members.items, fields) |member, *declared| {
        declared.* = .{ .name = member.name, .value = member.type_expr, .default_value = member.initial };

        if (member.release) |release| try releases.append(lowering.allocator, .{ .expression = release });
    }

    const method: node.Declaration = .{ .function = .{
        .name = "release",
        .parameters = try lowering.allocator.dupe(node.Field, &.{
            .{ .name = "zx_self", .value = try lowering.builder.expression(.{ .pointer = try lowering.builtin(.This, &.{}) }) },
            .{ .name = "zx_allocator", .value = try @import("../../intrinsics.zig").standardField(lowering, &.{ "mem", "Allocator" }) },
        }),
        .return_type = try lowering.builder.expression(.{ .primitive = .void }),
        .body = try releases.toOwnedSlice(lowering.allocator),
    } };

    const container = try lowering.builder.expression(.{ .container_type = .{ .fields = fields, .declarations = try lowering.allocator.dupe(node.Declaration, &.{method}) } });
    const call = try lowering.call(try lowering.field(try lowering.builder.identifier(self.name), "release"), &.{try lowering.builder.identifier("allocator")}, false);

    const statements = [_]node.Statement{
        .{ .variable = .{ .name = self.name, .type_expr = container, .value = try lowering.builder.expression(.{ .object = .{ .fields = &.{} } }) } },
        if (cleanup == .always) .{ .defer_expression = call } else .{ .errdefer_expression = call },
    };

    try body.insertSlice(lowering.allocator, self.position, &statements);
}

/// `zx_self.<field>` inside the release method.
pub fn own(lowering: *Lower, name: []const u8) Lower.Error!*const node.Expression {
    return lowering.field(try lowering.builder.identifier("zx_self"), name);
}
