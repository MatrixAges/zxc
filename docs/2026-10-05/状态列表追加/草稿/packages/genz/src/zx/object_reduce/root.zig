const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const Self = @This();

lowering: *Lower,
accumulator: *const node.Expression,
changed: *const node.Expression,
pub fn lower(lowering: *Lower, transform: ir.Transform) Lower.Error!?*const node.Expression {
    const type_id = lowering.program.expression(transform.body).type_id;

    if (transform.kind != .reduce or lowering.program.typeOf(type_id) != .object) return null;
    if (!try @import("analysis.zig").accepts(lowering.allocator, lowering.program, transform)) return null;

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(lowering, &body, try lowering.expr(transform.target));
    const initial = try aggregate.bind(lowering, &body, try lowering.expr(transform.initial.?));
    const accumulator_name = lowering.names[@intFromEnum(transform.parameters[0])];
    const changed_name = try lowering.fresh("state_changed");
    const self = Self{ .lowering = lowering, .accumulator = try lowering.builder.identifier(accumulator_name), .changed = try lowering.builder.identifier(changed_name) };

    try body.append(lowering.allocator, .{ .variable = .{ .name = accumulator_name, .type_expr = lowering.layouts[@intFromEnum(type_id)], .value = try lowering.builder.expression(.{ .dereference = initial }) } });
    try body.append(lowering.allocator, .{ .variable = .{ .name = changed_name, .value = try lowering.builder.expression(.{ .boolean = false }) } });

    var appends = try @import("append/root.zig").init(lowering, transform, &body);

    defer appends.restore();

    const loop = try self.statements(transform.body);

    appends.restore();

    const element = transform.parameters[1];

    try body.append(lowering.allocator, .{ .for_loop = .{ .iterable = source, .capture = if (lowering.used[@intFromEnum(element)]) lowering.names[@intFromEnum(element)] else "_", .body = loop } });
    try appends.finish(&body, self.accumulator);

    const result = try lowering.builder.expression(.{ .conditional = .{ .condition = self.changed, .yes = try lowering.construct(type_id, self.accumulator), .no = initial } });

    return try aggregate.finish(lowering, &body, result);
}

fn statements(self: Self, id: ir.ExprId) Lower.Error![]const node.Statement {
    const lowering = self.lowering;
    var body: std.ArrayList(node.Statement) = .empty;

    switch (lowering.program.expression(id).value) {
        .reference => {},
        .conditional => |value| try body.append(lowering.allocator, .{ .branch = .{ .condition = try lowering.expr(value.condition), .yes = try self.statements(value.yes), .no = try self.statements(value.no) } }),
        .object => {
            const next = try aggregate.objectValue(lowering, id);

            try body.append(lowering.allocator, .{ .assignment = .{ .target = self.accumulator, .value = next } });
            try body.append(lowering.allocator, .{ .assignment = .{ .target = self.changed, .value = try lowering.builder.expression(.{ .boolean = true }) } });
        },
        else => unreachable,
    }

    return body.toOwnedSlice(lowering.allocator);
}
