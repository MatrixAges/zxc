const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");

pub fn normalize(self: *Lower, id: ir.ExprId, value: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (self.iteration_value) |context| if (context.buffered(self.program.expression(id).type_id)) return value;

    var body: std.ArrayList(node.Statement) = .empty;
    const type_id = self.program.expression(id).type_id;
    const child = self.program.typeOf(type_id).list;

    const element = if (self.state_active)
        try @import("../state_value/elements.zig").typeExpr(self, type_id)
    else
        try @import("../iteration_value/types.zig").element(self, child);

    const lists = @import("../state_value/list.zig");
    const selected = lists.selected(self, type_id);
    const qualified = if (selected) try @import("../state_value/ownership.zig").clip(self, &body, id, value) else value;
    const evaluated = try aggregate.bind(self, &body, qualified);
    const source = try aggregate.bind(self, &body, try lists.items(self, type_id, evaluated));
    var copied: std.ArrayList(node.Statement) = .empty;
    const duplicate = try @import("../growth.zig").reserve(self, &copied, element, source, try self.field(source, "len"), false);

    const buffer = if (selected) try aggregate.bind(self, &body, try self.builder.expression(.{ .conditional = .{
        .condition = try lists.exclusive(self, evaluated),
        .yes = source,
        .no = try aggregate.finish(self, &copied, duplicate),
    } })) else try aggregate.finish(self, &copied, duplicate);

    const result = if (selected)
        try lists.proven(self, type_id, buffer, try self.builder.expression(.{ .boolean = true }), try self.builder.expression(.{ .boolean = true }))

    else
        buffer;

    return aggregate.finish(self, &body, result);
}
