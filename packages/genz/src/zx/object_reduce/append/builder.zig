const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const aggregate = @import("../../aggregate.zig");
const intrinsic = @import("../../intrinsics.zig");
const Self = @This();

buffer: *const node.Expression,
started: *const node.Expression,
enabled: ?*const node.Expression = null,
pub fn lower(self: Self, lowering: *Lower, id: ir.ExprId) Lower.Error!*const node.Expression {
    if (self.enabled) |enabled| {
        lowering.uses_buffers = true;

        var active = self;
        active.enabled = null;

        const previous = lowering.append_overrides.fetchRemove(id).?;

        defer lowering.append_overrides.put(lowering.allocator, id, previous.value) catch unreachable;

        return lowering.cast(lowering.types[@intFromEnum(lowering.program.expression(id).type_id)], try lowering.builder.expression(.{ .conditional = .{
            .condition = enabled,
            .yes = try active.lower(lowering, id),
            .no = try lowering.expr(id),
        } }));
    }

    const projection = lowering.program.expression(id).value.tuple_field;
    const operation = lowering.program.expression(projection.target).value.list_operation;
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(lowering, &body, try lowering.expr(operation.target));
    const argument = try aggregate.bind(lowering, &body, try lowering.expr(operation.arguments[0]));
    const added = if (operation.kind == .push) try lowering.builder.integer(1) else try lowering.field(argument, "len");
    const length = try intrinsic.standard(lowering, &.{ "math", "add" }, &.{ try lowering.builder.expression(.{ .primitive = .usize }), try lowering.field(source, "len"), added }, true);

    try body.append(lowering.allocator, .{ .discard = length });

    try body.append(lowering.allocator, .{ .branch = .{ .condition = try lowering.builder.expression(.{ .unary = .{ .operator = .not, .operand = self.started } }), .yes = try lowering.allocator.dupe(node.Statement, &.{
        .{ .expression = try self.method(lowering, "appendSlice", &.{source}, true) },
        .{ .assignment = .{ .target = self.started, .value = try lowering.builder.expression(.{ .boolean = true }) } },
    }), .no = &.{} } });

    try body.append(lowering.allocator, .{ .expression = try self.method(lowering, if (operation.kind == .push) "append" else "appendSlice", &.{argument}, true) });

    return aggregate.finish(lowering, &body, try lowering.field(self.buffer, "items"));
}

pub fn method(self: Self, lowering: *Lower, name: []const u8, arguments: []const *const node.Expression, fallible: bool) Lower.Error!*const node.Expression {
    const values = try lowering.allocator.alloc(*const node.Expression, arguments.len + 1);
    values[0] = try lowering.builder.identifier("allocator");

    @memcpy(values[1..], arguments);

    return lowering.call(try lowering.field(self.buffer, name), values, fallible);
}
