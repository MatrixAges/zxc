const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const intrinsic = @import("../intrinsics.zig");
const buffer = @import("buffer.zig");

pub fn operation(self: *Context, id: ir.ExprId) Lower.Error!node.ExpressionId {
    const lowering = self.lowering;
    const row = lowering.program.expression(id);
    const operation_value = row.value.list_operation;
    const list_type = lowering.program.expression(operation_value.target).type_id;
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(lowering, &body, try lowering.expr(operation_value.target));
    const owner = try lowering.field(source, "owner");
    const items = try lowering.field(source, "items");
    const length = try lowering.field(items, "len");

    const changed = switch (operation_value.kind) {
        .push => blk: {
            const value = try aggregate.bind(lowering, &body, try lowering.expr(operation_value.arguments[0]));

            try body.append(lowering.allocator, .{ .discard = try intrinsic.standard(lowering, &.{ "math", "add" }, &.{ try lowering.builder.expression(.{ .primitive = .usize }), length, try lowering.builder.integer(1) }, true) });
            try buffer.prepare(self, &body, source);
            try body.append(lowering.allocator, .{ .expression = try lowering.call(try lowering.field(owner, "append"), &.{ try lowering.builder.identifier("allocator"), value }, true) });

            break :blk try pair(lowering, try buffer.view(self, list_type, owner, try lowering.field(owner, "items"), true), try lowering.builder.expression(.unit));
        },
        .pop => blk: {
            const last = try intrinsic.binary(lowering, .subtract, length, try lowering.builder.integer(1));
            const remaining = try lowering.builder.expression(.{ .slice = .{ .target = items, .start = null, .end = last } });
            const value = try lowering.builder.expression(.{ .index = .{ .target = items, .index = last } });

            const updated = try lowering.builder.expression(.{ .object = .{ .type_expr = try @import("types.zig").get(self, list_type), .fields = try lowering.allocator.dupe(node.Field, &.{
                .{ .name = "owner", .value = owner },
                .{ .name = "items", .value = remaining },
                .{ .name = "owned", .value = try lowering.field(source, "owned") },
            }) } });

            break :blk try lowering.builder.expression(.{ .conditional = .{
                .condition = try intrinsic.binary(lowering, .equal, length, try lowering.builder.integer(0)),
                .yes = try pair(lowering, source, try lowering.builder.expression(.null_value)),
                .no = try pair(lowering, updated, value),
            } });
        },
        else => unreachable,
    };

    return aggregate.finish(lowering, &body, try lowering.cast(try @import("types.zig").get(self, row.type_id), changed));
}

pub fn update(self: *Context, id: ir.ExprId) Lower.Error!node.ExpressionId {
    const lowering = self.lowering;
    const write = lowering.program.expression(id).value.list_update;
    const list_type = lowering.program.expression(write.target).type_id;
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(lowering, &body, try lowering.expr(write.target));
    const index = try aggregate.bind(lowering, &body, try lowering.expr(write.index));
    const owner = try lowering.field(source, "owner");
    const length = try lowering.field(try lowering.field(source, "items"), "len");

    try intrinsic.failIf(lowering, &body, try intrinsic.binary(lowering, .greater_equal, index, length), "IndexOutOfBounds");

    const value = try aggregate.bind(lowering, &body, try lowering.expr(write.value));

    try buffer.prepare(self, &body, source);
    try body.append(lowering.allocator, .{ .assignment = .{ .target = try lowering.builder.expression(.{ .index = .{ .target = try lowering.field(owner, "items"), .index = try lowering.builtin(.intCast, &.{index}) } }), .value = value } });

    return aggregate.finish(lowering, &body, try buffer.view(self, list_type, owner, try lowering.field(owner, "items"), true));
}

fn pair(lowering: *Lower, left: node.ExpressionId, right: node.ExpressionId) Lower.Error!node.ExpressionId {
    return lowering.builder.expression(.{ .tuple = try lowering.allocator.dupe(node.ExpressionId, &.{ left, right }) });
}
