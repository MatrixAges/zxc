const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const ownership = @import("../ownership.zig");

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, value: node.ExpressionId, slot: u32) Lower.Error!bool {
    if (self.program.typeOf(type_id) == .optional) return false;

    const writes = leaves(self, id, type_id, slot) orelse return false;

    if (writes < 2) return false;

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

    const present = for (self.task_declarations.items) |declaration| {
        if (declaration == .function and std.mem.eql(u8, declaration.function.name, name)) break true;
    } else false;

    if (!present) {
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

fn leaves(self: *const Lower, id: ir.ExprId, type_id: ir.TypeId, slot: u32) ?usize {
    if (!ownership.needed(self, id, type_id, slot)) return 0;
    if (self.state_plan.referenced(type_id)) return null;

    var offset = slot;
    var total: usize = 0;

    switch (self.program.typeOf(type_id)) {
        .list => return 1,
        .optional => |child| return leaves(self, id, child, slot),
        .object => |fields| for (0..fields.len) |index| {
            const child = fields.at(index).type_id;

            total += leaves(self, id, child, offset) orelse return null;
            offset += ownership.count(self, child);
        },
        .tuple => |fields| for (0..fields.len) |index| {
            const child = fields.at(index);

            total += leaves(self, id, child, offset) orelse return null;
            offset += ownership.count(self, child);
        },
        else => {},
    }

    return total;
}
