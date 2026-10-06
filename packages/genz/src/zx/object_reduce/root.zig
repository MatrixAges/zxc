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
    if (!lowering.state_active and !lowering.allows_allocation) return null;
    if (!try @import("analysis.zig").accepts(lowering.allocator, lowering.program, transform, lowering.value_functions)) return null;

    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(lowering, &body, try lowering.expr(transform.target));
    const initial = try aggregate.bind(lowering, &body, try lowering.expr(transform.initial.?));
    const state_scope = if (!lowering.state_active and lowering.state_plan.selected[@backingInt(type_id)]) try @import("../state_value/root.zig").enter(lowering) else null;

    defer if (state_scope) |scope| scope.restore();

    const state_initial = if (state_scope != null) try @import("../state_value/conversion.zig").convert(lowering, &body, type_id, initial, .value) else initial;
    const accumulator_name = lowering.names[@backingInt(transform.parameters[0])];
    const changed_name = try lowering.fresh("state_changed");
    const self = Self{ .lowering = lowering, .accumulator = try lowering.builder.identifier(accumulator_name), .changed = try lowering.builder.identifier(changed_name) };
    const state_value = @import("../state_value/root.zig").selected(lowering, type_id);

    try body.append(lowering.allocator, .{ .variable = .{ .name = accumulator_name, .type_expr = lowering.layouts[@backingInt(type_id)], .value = if (state_value) state_initial else try lowering.builder.expression(.{ .dereference = initial }) } });
    try body.append(lowering.allocator, .{ .variable = .{ .name = changed_name, .value = try lowering.builder.expression(.{ .boolean = false }) } });

    var appends = try @import("append/root.zig").init(lowering, transform, &body);

    defer appends.restore();

    const accumulator_symbol = transform.parameters[0];
    const already_stacked = lowering.stack_symbols.contains(accumulator_symbol);
    const already_state = lowering.state_symbols.contains(accumulator_symbol);

    if (state_value) try lowering.state_symbols.put(lowering.allocator, accumulator_symbol, {}) else try lowering.stack_symbols.put(lowering.allocator, accumulator_symbol, {});

    defer if (state_value and !already_state) {
        _ = lowering.state_symbols.remove(accumulator_symbol);
    };

    defer if (!already_stacked) {
        _ = lowering.stack_symbols.remove(accumulator_symbol);
    };

    const loop = try self.statements(transform.body);

    appends.restore();

    const element = transform.parameters[1];

    try body.append(lowering.allocator, .{ .for_loop = .{ .iterable = source, .capture = if (lowering.used[@backingInt(element)]) lowering.names[@backingInt(element)] else "_", .body = loop } });
    try appends.finish(&body, self.accumulator);

    var converted_body: std.ArrayList(node.Statement) = .empty;
    const converted = if (state_scope != null) try @import("../state_value/conversion.zig").convert(lowering, &converted_body, type_id, self.accumulator, .pointer) else try lowering.construct(type_id, self.accumulator);
    const result = try lowering.builder.expression(.{ .conditional = .{ .condition = self.changed, .yes = try aggregate.finish(lowering, &converted_body, converted), .no = initial } });

    return try aggregate.finish(lowering, &body, result);
}

fn statements(self: Self, id: ir.ExprId) Lower.Error![]const node.Statement {
    const lowering = self.lowering;
    var body: std.ArrayList(node.Statement) = .empty;

    switch (lowering.program.expression(id).value) {
        .reference => {},
        .conditional => |value| try body.append(lowering.allocator, .{ .branch = .{ .condition = try lowering.expr(value.condition), .yes = try self.statements(value.yes), .no = try self.statements(value.no) } }),
        .object, .call => {
            const next = try @import("../value_call/root.zig").expression(lowering, id);

            try body.append(lowering.allocator, .{ .assignment = .{ .target = self.accumulator, .value = next } });
            try body.append(lowering.allocator, .{ .assignment = .{ .target = self.changed, .value = try lowering.builder.expression(.{ .boolean = true }) } });
        },
        else => unreachable,
    }

    return body.toOwnedSlice(lowering.allocator);
}
