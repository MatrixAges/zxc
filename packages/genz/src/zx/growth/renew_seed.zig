const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn renew(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, state: node.ExpressionId, path: []const u32) Lower.Error!void {
    if (self.iteration_value) |context| if (context.bufferedPath(type_id, path)) return;

    const steps = try self.allocator.alloc(node.ExpressionId, path.len);
    const text = try self.builder.expression(.{ .const_slice = try self.builder.expression(.{ .primitive = .u8 }) });
    var current = type_id;

    for (path, steps) |step, *item| {
        while (self.program.typeOf(current) == .optional) current = self.program.typeOf(current).optional;

        const member: struct { name: []const u8, type_id: ir.TypeId } = switch (self.program.typeOf(current)) {
            .object => |fields| .{ .name = fields.at(step).name, .type_id = fields.at(step).type_id },
            .tuple => |items| .{ .name = try std.fmt.allocPrint(self.allocator, "{d}", .{step}), .type_id = items.at(step) },
            else => unreachable,
        };

        item.* = try self.builder.expression(.{ .tuple = try self.allocator.dupe(node.ExpressionId, &.{ try self.builder.string(member.name), try self.builder.string(try @import("../state_value/origin.zig").name(self, current)) }) });
        current = member.type_id;
    }

    const pair = try self.builder.expression(.{ .fixed_array_type = .{ .length = try self.builder.integer(2), .element = text } });
    const names = try self.builder.expression(.{ .address_of = try self.builder.expression(.{ .array = .{ .element_type = pair, .values = steps } }) });

    try body.append(self.allocator, .{ .expression = try self.call(try reference(self), &.{ try self.builder.identifier("allocator"), try self.builder.expression(.{ .address_of = state }), names, try self.builder.expression(.{ .boolean = !self.may_grow }) }, true) });
}

fn reference(self: *Lower) Lower.Error!node.ExpressionId {
    if (self.shared_types) return self.field(try self.builder.identifier("zx_abi"), "zxRenew");

    return self.builder.identifier("zxRenew");
}
