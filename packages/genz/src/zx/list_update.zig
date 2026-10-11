const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsics = @import("intrinsics.zig");

/// Writes one element: in place when the plan proves the target unique, into a copy otherwise.
pub fn lower(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    const update = self.program.expression(id).value.list_update;
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try self.expr(update.target));
    const index = try aggregate.bind(self, &body, try self.expr(update.index));

    try intrinsics.failIf(self, &body, try intrinsics.binary(self, .greater_equal, index, try self.field(source, "len")), "IndexOutOfBounds");

    const value = try aggregate.bind(self, &body, try self.expr(update.value));
    const element = try @import("iteration_value/types.zig").element(self, self.program.typeOf(self.program.expression(update.target).type_id).list);
    const buffer = if (self.plan.get(id).in_place) try aggregate.bind(self, &body, try self.builtin(.constCast, &.{source})) else try aggregate.bind(self, &body, try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ element, source }, true));
    const slot = try self.builder.expression(.{ .index = .{ .target = buffer, .index = try self.builtin(.intCast, &.{index}) } });

    try body.append(self.allocator, .{ .assignment = .{ .target = slot, .value = value } });

    return aggregate.finish(self, &body, buffer);
}
