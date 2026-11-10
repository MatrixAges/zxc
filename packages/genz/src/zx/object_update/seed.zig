const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const aggregate = @import("../aggregate.zig");
const Change = @import("../object_update.zig").Change;

pub fn lower(lowering: *Lower, change: Change, parent: *std.ArrayList(node.Statement)) Lower.Error!node.ExpressionId {
    const name = try lowering.fresh("updated");
    const layout = try lowering.layoutExpr(change.type_id);
    const selected = lowering.state_plan.selected[@backingInt(change.type_id)];
    const source = try lowering.expr(change.reference);
    const initial = if (selected) source else try lowering.builder.expression(.{ .dereference = source });
    const value = if (change.multiple) null else try operand(lowering, parent, change.field.value, selected);
    const value_name = try lowering.fresh("operand");
    const label = try lowering.fresh("block");
    var body: std.ArrayList(node.Statement) = .empty;
    const target = try lowering.builder.identifier(name);

    try body.append(lowering.allocator, .{ .variable = .{
        .name = name,
        .type_expr = layout,
        .value = initial,
    } });

    if (change.multiple) {
        const object = lowering.program.expression(change.object.?).value.object;
        const values = try lowering.allocator.alloc(u32, object.fields.len);

        for (values, 0..) |*item, index| {
            const field = object.fields.at(index);

            item.* = if (unchanged(lowering, change.reference, field)) 0 else @backingInt(try operand(lowering, parent, field.value, selected));
        }

        for (values, 0..) |item, index| {
            if (unchanged(lowering, change.reference, object.fields.at(index))) continue;

            const bound = try std.fmt.allocPrint(lowering.allocator, "{s}_value_{d}", .{ name, index });

            try body.append(lowering.allocator, .{ .constant = .{ .name = bound, .value = @fromBackingInt(item) } });
        }

        for (0..object.fields.len) |index| {
            const field = object.fields.at(index);

            if (unchanged(lowering, change.reference, field)) continue;

            const bound = try std.fmt.allocPrint(lowering.allocator, "{s}_value_{d}", .{ name, index });
            const member = lowering.program.typeOf(change.type_id).object.at(field.index);

            try body.append(lowering.allocator, .{ .assignment = .{
                .target = try lowering.field(target, member.name),
                .value = try lowering.builder.identifier(bound),
            } });
        }
    } else {
        const field = lowering.program.typeOf(change.type_id).object.at(change.field.index);

        try body.append(lowering.allocator, .{ .constant = .{ .name = value_name, .value = value.? } });

        try body.append(lowering.allocator, .{ .assignment = .{
            .target = try lowering.field(target, field.name),
            .value = try lowering.builder.identifier(value_name),
        } });
    }

    if (selected) try body.append(lowering.allocator, .{ .assignment = .{
        .target = try lowering.field(target, try @import("../state_value/origin.zig").name(lowering, change.type_id)),
        .value = try lowering.builder.expression(.null_value),
    } });

    try body.append(lowering.allocator, .{ .break_value = .{ .label = label, .value = target } });

    return lowering.builder.expression(.{ .block = .{ .label = label, .statements = try lowering.builder.statements(body.items) } });
}

pub fn match(lowering: *const Lower, id: ir.ExprId) ?Change {
    return matchMode(lowering, id, false);
}

pub fn matchEvaluated(lowering: *const Lower, id: ir.ExprId) ?Change {
    return matchMode(lowering, id, true);
}

fn matchMode(lowering: *const Lower, id: ir.ExprId, evaluated: bool) ?Change {
    if (!lowering.state_active or lowering.iteration_value != null or lowering.loop_fields != null) return null;

    const row = lowering.program.expression(id);

    if (row.value != .object or lowering.program.typeOf(row.type_id) != .object) return null;
    if (lowering.state_plan.referenced(row.type_id)) return null;
    if (!lowering.state_plan.selected[@backingInt(row.type_id)] and !evaluated) return null;
    if (!plain(lowering, id) or lowering.cache.contains(id)) return null;

    const object = row.value.object;

    if (object.fields.len < 2 or object.fields.len != lowering.program.typeOf(row.type_id).object.len) return null;

    var reference: ?ir.ExprId = null;

    for (0..object.fields.len) |index| {
        const field = object.fields.at(index);
        const projection = lowering.program.expression(field.value).value;

        if (projection != .field or projection.field.index != field.index) continue;

        const target = lowering.program.expression(projection.field.target);

        if (target.type_id != row.type_id) continue;

        if (target.value != .reference) {
            if (!evaluated or target.value != .field or !lowering.cache.contains(projection.field.target)) continue;
        }

        reference = projection.field.target;

        break;
    }

    const source = reference orelse return null;
    const previous = owner(lowering, source) orelse return null;

    if (!lowering.state_symbols.contains(previous) or lowering.stack_symbols.contains(previous)) return null;

    if (!evaluated) for (object.evaluation) |item| {
        const value = lowering.program.expression(item).value;

        if (value != .reference or value.reference != previous or !plain(lowering, item)) return null;
    };

    var changed: ?ir.ObjectField = null;
    var multiple = false;

    for (0..object.fields.len) |index| {
        const field = object.fields.at(index);

        if (unchanged(lowering, source, field)) continue;

        if (changed != null) {
            if (!evaluated) return null;

            multiple = true;
        } else changed = field;
    }

    return .{
        .previous = previous,
        .reference = source,
        .field = changed orelse return null,
        .type_id = row.type_id,
        .object = id,
        .multiple = multiple,
    };
}

fn operand(lowering: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, selected: bool) Lower.Error!node.ExpressionId {
    const value = try lowering.expr(id);

    if (selected) return value;

    const bound = try aggregate.bind(lowering, body, value);

    return @import("../state_value/conversion.zig").convert(lowering, body, lowering.program.expression(id).type_id, bound, .pointer);
}

fn owner(lowering: *const Lower, id: ir.ExprId) ?ir.SymbolId {
    var current = id;

    while (plain(lowering, current)) {
        switch (lowering.program.expression(current).value) {
            .reference => |symbol| return symbol,
            .field => |field| current = field.target,
            else => return null,
        }
    }

    return null;
}

fn unchanged(lowering: *const Lower, reference: ir.ExprId, field: ir.ObjectField) bool {
    const value = lowering.program.expression(field.value).value;

    if (value != .field or value.field.index != field.index or !plain(lowering, field.value)) return false;

    var left = reference;
    var right = value.field.target;

    while (plain(lowering, left) and plain(lowering, right)) {
        const a = lowering.program.expression(left).value;
        const b = lowering.program.expression(right).value;

        if (a == .reference and b == .reference) return a.reference == b.reference;
        if (a != .field or b != .field or a.field.index != b.field.index) return false;

        left = a.field.target;
        right = b.field.target;
    }

    return false;
}

fn plain(lowering: *const Lower, id: ir.ExprId) bool {
    const flags = lowering.plan.get(id);

    return !flags.normalize and !flags.renew;
}
