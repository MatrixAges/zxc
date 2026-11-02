const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const intrinsic = @import("../intrinsics.zig");

pub fn lower(context: *Context, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, source: node.ExpressionId) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const kind = try self.typeExpr(type_id);

    const empty = try self.builder.expression(.{ .address_of = try self.builder.expression(.{ .array = .{
        .element_type = try self.typeExpr(self.program.typeOf(type_id).list),
        .values = &.{},
    } }) });

    const result_name = try self.fresh("state_owned");
    const cleanup_name = try self.fresh("state_owned_cleanup");
    const ready_name = try self.fresh("state_transferred");
    const result = try self.builder.identifier(result_name);
    const cleanup = try self.builder.identifier(cleanup_name);
    const ready = try self.builder.identifier(ready_name);
    const allocator = try self.builder.identifier("allocator");

    try body.append(self.allocator, .{ .variable = .{ .name = result_name, .type_expr = kind, .value = empty } });
    try body.append(self.allocator, .{ .variable = .{ .name = cleanup_name, .type_expr = kind, .value = empty } });
    try body.append(self.allocator, .{ .variable = .{ .name = ready_name, .value = try self.builder.expression(.{ .boolean = false }) } });
    try body.append(self.allocator, .{ .errdefer_expression = try self.call(try self.field(allocator, "free"), &.{cleanup}, false) });

    var evaluate: std.ArrayList(node.Statement) = .empty;
    const value = try aggregate.bind(self, &evaluate, source);
    const owner = try self.field(value, "owner");
    const items = try self.field(value, "items");
    const owned = try self.field(value, "owned");
    var take: std.ArrayList(node.Statement) = .empty;

    try take.append(self.allocator, .{ .assignment = .{ .target = try self.field(try self.field(owner, "items"), "len"), .value = try self.field(items, "len") } });

    const transferred = try self.call(try self.field(owner, "toOwnedSlice"), &.{allocator}, true);
    var shared = try self.builder.expression(.{ .boolean = false });

    var chosen = try self.builder.expression(.{ .conditional = .{
        .condition = owned,
        .yes = try aggregate.finish(self, &take, transferred),
        .no = items,
    } });

    for (context.transfers.items) |previous| {
        if (previous.type_id != type_id) continue;

        const same = try intrinsic.binary(self, .logical_and, previous.ready, try intrinsic.binary(self, .equal, owner, previous.owner));
        shared = try intrinsic.binary(self, .logical_or, shared, same);
        chosen = try self.builder.expression(.{ .conditional = .{ .condition = same, .yes = previous.value, .no = chosen } });
    }

    const cleanup_owned = try intrinsic.binary(self, .logical_and, owned, try self.builder.expression(.{ .unary = .{ .operator = .not, .operand = shared } }));

    try evaluate.append(self.allocator, .{ .assignment = .{ .target = result, .value = chosen } });
    try evaluate.append(self.allocator, .{ .assignment = .{ .target = cleanup, .value = try self.builder.expression(.{ .conditional = .{ .condition = cleanup_owned, .yes = result, .no = empty } }) } });
    try evaluate.append(self.allocator, .{ .assignment = .{ .target = ready, .value = try self.builder.expression(.{ .boolean = true }) } });

    const expression = try self.builder.expression(.{ .conditional = .{
        .condition = ready,
        .yes = result,
        .no = try aggregate.finish(self, &evaluate, result),
    } });

    try context.transfers.append(self.allocator, .{ .type_id = type_id, .owner = try self.field(source, "owner"), .value = result, .ready = ready });

    return expression;
}
