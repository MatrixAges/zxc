const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");
const intrinsics = @import("intrinsics.zig");

/// Writes one element: in place when the plan proves the target unique, into a copy otherwise, which keeps the header of
/// a headered target.
pub fn lower(self: *Lower, id: ir.ExprId) Lower.Error!node.ExpressionId {
    const update = self.program.expression(id).value.list_update;
    var body: std.ArrayList(node.Statement) = .empty;
    const type_id = self.program.expression(update.target).type_id;
    const source_value = try aggregate.bind(self, &body, try self.expr(update.target));
    const source = try @import("state_value/list.zig").items(self, type_id, source_value);
    const index = try aggregate.bind(self, &body, try self.expr(update.index));

    try intrinsics.failIf(self, &body, try intrinsics.binary(self, .greater_equal, index, try self.field(source, "len")), "IndexOutOfBounds");

    const evaluated = try aggregate.bind(self, &body, try self.expr(update.value));
    const value = try @import("state_value/elements.zig").write(self, &body, type_id, evaluated);
    const element = try @import("state_value/elements.zig").typeExpr(self, type_id);
    const flags = self.plan.get(id);

    const buffer = if (flags.in_place)
        try aggregate.bind(self, &body, try self.builtin(.constCast, &.{source}))

    else if (flags.grow)
        try @import("growth.zig").reserve(self, &body, element, source, try self.field(source, "len"), false)
    else
        try aggregate.bind(self, &body, try self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ element, source }, true));

    const slot = try self.builder.expression(.{ .index = .{ .target = buffer, .index = try self.builtin(.intCast, &.{index}) } });

    try body.append(self.allocator, .{ .assignment = .{ .target = slot, .value = value } });

    const result = if (@import("state_value/list.zig").selected(self, type_id)) try @import("state_value/list.zig").create(self, type_id, buffer, if (flags.in_place) try self.field(source_value, "headered") else try self.builder.expression(.{ .boolean = flags.grow })) else buffer;

    return aggregate.finish(self, &body, result);
}
