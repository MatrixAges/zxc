const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Self = @import("lower.zig");

pub fn construct(self: *Self, type_id: ir.TypeId, value: node.ExpressionId) Self.Error!node.ExpressionId {
    if (@import("state_value/root.zig").selected(self, type_id)) {
        const result = try self.cast(try self.layoutExpr(type_id), try @import("state_value/origin_seed.zig").tuple(self, type_id, value));

        if (!self.state_plan.referenced(type_id)) return result;

        var prefix: std.ArrayList(node.Statement) = .empty;
        const pointer = try @import("state_value/reference_seed.zig").store(self, &prefix, type_id, result);

        return @import("aggregate.zig").finish(self, &prefix, pointer);
    }

    var body: std.ArrayList(node.Statement) = .empty;
    const layout = try self.layoutExpr(type_id);
    const pointer = try @import("aggregate.zig").bind(self, &body, try self.call(try self.field(try self.builder.identifier("allocator"), "create"), &.{layout}, true));

    try body.append(self.allocator, .{ .assignment = .{ .target = try self.builder.expression(.{ .dereference = pointer }), .value = try self.cast(layout, value) } });

    return @import("aggregate.zig").finish(self, &body, try self.cast(try self.typeExpr(type_id), pointer));
}
