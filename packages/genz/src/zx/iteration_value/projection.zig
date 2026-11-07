const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const Consumer = @import("../iteration_consumer.zig").Consumer;

pub fn read(self: *Context, selected: Consumer, id: ir.ExprId, state: node.ExpressionId) Lower.Error!node.ExpressionId {
    const lowering = self.lowering;
    const expression = lowering.program.expression(id);

    return switch (expression.value) {
        .reference => |symbol| if (symbol == selected.symbol) state else unreachable,
        .field, .tuple_field => |field| blk: {
            const target = try read(self, selected, field.target, state);
            const kind = lowering.program.typeOf(lowering.program.expression(field.target).type_id);
            const name = if (expression.value == .field) kind.object.at(field.index).name else try std.fmt.allocPrint(lowering.allocator, "{d}", .{field.index});
            const value = try lowering.field(target, name);

            break :blk if (self.buffered(expression.type_id)) try redirect(self, expression.type_id, value) else value;
        },
        .index => |item| blk: {
            const target = try read(self, selected, item.target, state);
            const items = if (self.buffered(lowering.program.expression(item.target).type_id)) try lowering.field(target, "items") else target;

            break :blk @import("../intrinsics.zig").index(lowering, items, try lowering.expr(item.index));
        },
        .length => |child| blk: {
            const target = try read(self, selected, child, state);
            const items = if (self.buffered(lowering.program.expression(child).type_id)) try lowering.field(target, "items") else target;

            break :blk lowering.cast(try lowering.typeExpr(expression.type_id), try lowering.field(items, "len"));
        },
        else => unreachable,
    };
}

fn redirect(self: *Context, type_id: ir.TypeId, source: node.ExpressionId) Lower.Error!node.ExpressionId {
    const lowering = self.lowering;
    const owner = try lowering.field(source, "owner");
    var items = try lowering.field(source, "items");
    var records = self.transfers.iterator();

    while (records.next()) |previous| {
        if (previous.type_id != type_id) continue;

        items = try lowering.builder.expression(.{ .conditional = .{
            .condition = try @import("../intrinsics.zig").binary(lowering, .logical_and, previous.ready, try @import("../intrinsics.zig").binary(lowering, .equal, owner, previous.owner)),
            .yes = previous.value,
            .no = items,
        } });
    }

    return lowering.builder.expression(.{ .object = .{ .type_expr = try @import("types.zig").get(self, type_id), .fields = try lowering.allocator.dupe(node.Field, &.{
        .{ .name = "owner", .value = owner },
        .{ .name = "items", .value = items },
        .{ .name = "owned", .value = try lowering.field(source, "owned") },
    }) } });
}
