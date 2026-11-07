const std = @import("std");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const Change = @import("../object_update.zig").Change;

pub fn lower(lowering: *Lower, change: Change) Lower.Error!node.ExpressionId {
    var body: std.ArrayList(node.Statement) = .empty;
    const name = try lowering.fresh("updated");
    const target = try lowering.builder.identifier(name);

    try body.append(lowering.allocator, .{ .variable = .{
        .name = name,
        .type_expr = try lowering.layoutExpr(change.type_id),
        .value = try lowering.expr(change.reference),
    } });

    const value = try aggregate.bind(lowering, &body, try lowering.expr(change.field.value));
    const field = lowering.program.typeOf(change.type_id).object.at(change.field.index);

    try body.append(lowering.allocator, .{ .assignment = .{ .target = try lowering.field(target, field.name), .value = value } });
    try body.append(lowering.allocator, .{ .assignment = .{ .target = try lowering.field(target, try @import("../state_value/origin.zig").name(lowering, change.type_id)), .value = try lowering.builder.expression(.null_value) } });

    return try aggregate.finish(lowering, &body, target);
}
