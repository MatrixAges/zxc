const ir = @import("zx").ir;
const std = @import("std");
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn lower(self: *Context, id: ir.TypeId, items: []const ir.ExprId) Lower.Error!*const node.Expression {
    const lowering = self.lowering;
    const element = try @import("types.zig").get(self, lowering.program.typeOf(id).list);
    var body: std.ArrayList(node.Statement) = .empty;
    const values = try lowering.allocator.alloc(*const node.Expression, items.len);

    for (items, values) |item, *value| value.* = try aggregate.bind(lowering, &body, try lowering.expr(item));

    const array = try lowering.builder.expression(.{ .array = .{ .element_type = element, .values = values } });
    const address = try lowering.builder.expression(.{ .address_of = array });
    const result = if (items.len == 0) address else try lowering.call(try lowering.field(try lowering.builder.identifier("allocator"), "dupe"), &.{ element, address }, true);

    return aggregate.finish(lowering, &body, try lowering.cast(try @import("types.zig").get(self, id), result));
}
