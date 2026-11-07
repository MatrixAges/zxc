const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const ownership = @import("../ownership.zig");

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!bool {
    if (!@import("query_seed.zig").outlined(self, id, type_id, slot)) return false;

    const type_expr = try @import("../../types.zig").get(self, self.state_types, type_id);
    const base = if (self.type_names) |names| names[@backingInt(type_id)] else try std.fmt.allocPrint(self.allocator, "zx_type_{d}", .{@backingInt(type_id)});
    const state_name = try self.state_plan.name(self.allocator, type_id, base);
    var hash = zx.Sha256.init(.{});

    hash.update(state_name);
    hash.update(&.{0});

    for (0..ownership.count(self, type_id)) |index| hash.update(&.{@intFromBool(ownership.eligible(self, id, slot + @as(u32, @intCast(index))))});

    var digest: [32]u8 = undefined;

    hash.final(&digest);

    const name = try std.fmt.allocPrint(self.allocator, "zx_weaken_{s}", .{std.fmt.bytesToHex(digest, .lower)});

    if (!self.task_declarations.containsFunction(name)) {
        var statements: std.ArrayList(node.Statement) = .empty;

        try ownership.clear(self, &statements, id, type_id, try self.builder.identifier("value"), slot);

        try self.task_declarations.append(self.allocator, .{ .function = .{
            .name = name,
            .parameters = try self.allocator.dupe(node.Field, &.{.{ .name = "value", .value = try self.builder.expression(.{ .pointer = type_expr }) }}),
            .return_type = try self.builder.expression(.{ .primitive = .void }),
            .body = try self.builder.statements(statements.items),
        } });
    }

    try body.append(self.allocator, .{ .expression = try self.call(try self.builder.identifier(name), &.{try self.builder.expression(.{ .address_of = value })}, false) });

    return true;
}
